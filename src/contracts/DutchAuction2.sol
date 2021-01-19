// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IERC20 {
    
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);
    
    function approve(address spender, uint256 amount) external ;
    
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

}


contract DutchAuction {

    /*
     *  Events
     */
    event BidSubmission(address indexed sender, uint256 amount);

    /*
     *  Constants
     */
    uint constant public MAX_TOKENS_SOLD = 400; // 9M

    /*
     *  Storage
     */
    IERC20 public questTokens;
    address public owner;
    uint public bid_start_price;      //per token
    uint public bid_current_price;    //per token
    uint public bid_final_price;      //per token
    uint public bid_start_time;
    uint public bid_current_time;
    uint public bid_end_time;
    uint public availaible_tokens_for_bid = MAX_TOKENS_SOLD;
    
    address[] public bidders;
    address[] public winner_bidders;
    
    struct Bid{
        uint256 bid_time;
        uint256 bid_price;
        uint256 bid_quantity;
        bool bid_placed;
        bool bid_quantity_transfer;
        bool bid_price_transfer;
        bool bid_accepted;
    }
    
    mapping (address => Bid) public bids;
    Stages public stage;

    /*
     *  Enums
     */
    enum Stages {
        AuctionDeployed,
        AuctionSetUp,
        AuctionStarted,
        AuctionEnded,
        TradingStarted
    }

    /*
     *  Modifiers
     */
    modifier atStage(Stages _stage) {
        require(stage == _stage,"wrong stage");
        _;
    }

    modifier isOwner() {
        require(msg.sender == owner,"caller is not owner");
        _;
    }


 
    constructor() public {
        
        owner = msg.sender;
        bid_start_price= 100;
        bid_current_price = 100;
        bid_final_price = 90;
        stage = Stages.AuctionDeployed;
        bid_start_time = 1608717600;
        bid_current_time = bid_start_time;
        bid_end_time = 1608721200;
    }

    /// @dev Setup function sets external contracts' addresses.
    /// @param _questToken ERC20 token address.
    function setup(address _questToken) public isOwner atStage(Stages.AuctionDeployed){
        
        require(_questToken != address(0));
        questTokens = IERC20(_questToken);
        
        // Validate token balance
        require(questTokens.balanceOf(address(this)) == MAX_TOKENS_SOLD,"tokens quantity to be bid not match with auction contract");
        stage = Stages.AuctionSetUp;
    }

    /// @dev Starts auction and sets startBlock.
    function startAuction() public atStage(Stages.AuctionSetUp){
        
        require(now == bid_start_time,"Auction started early");
        stage = Stages.AuctionStarted;
    }
    
    function changeStageTemp() public {
        stage = Stages.AuctionStarted;
    }

    function changeCurrentPrice() public atStage(Stages.AuctionStarted) {
        
        //Price changes every 10 minutes;   
        if(now == (bid_current_time+600)){
            bid_current_time = now;
            bid_current_price = bid_current_price - 1;
            if(bid_current_price < bid_final_price)
            stage = Stages.AuctionEnded;
        }
    }


    function bid(address receiver,uint256 amount) public atStage(Stages.AuctionStarted)
    {
        uint temp_price = bid_current_price;
        uint temp_time = now;
        require(receiver != address(0),"bidder is of 0 address");
        require(amount != 0);
        require(bids[receiver].bid_placed == false,"bid already placed");
        
        // if(now >= bid_end_time){
        //     //bidding stop
        //     stage = Stages.AuctionEnded;
        //     finalizeAuction();
        // }
        // else{
        //     //bidding continues
            
            bids[receiver].bid_time = temp_time;
            bids[receiver].bid_price = temp_price;
            bids[receiver].bid_quantity = amount;
            bids[receiver].bid_placed = true;
            bidders.push(receiver);
            emit BidSubmission(receiver,amount);
            
            if( amount >= availaible_tokens_for_bid){
            //do some change and stop bidding
            availaible_tokens_for_bid = 0 ;
            stage = Stages.AuctionEnded;
            finalizeAuction();
            }else{
                availaible_tokens_for_bid -= amount;
            }
            
        // }
        
    }

   
    /*
     *  Private functions
     */
    function finalizeAuction() private atStage(Stages.AuctionEnded)
    {
        if(availaible_tokens_for_bid == 0){
            
            uint temp = MAX_TOKENS_SOLD;
            
            for(uint i=0;i<bidders.length;i++){
                
                address temp_bid_add = bidders[i];
                if(bids[temp_bid_add].bid_quantity <= temp){
                   temp -= bids[temp_bid_add].bid_quantity;
                   bids[temp_bid_add].bid_accepted = true;
                   winner_bidders.push(temp_bid_add);
                }
                
            }
        }
        else if(bidders.length>0)
        { 
            uint temp_price = bids[bidders[bidders.length - 1]].bid_price;  
            for(uint i=0;i<bidders.length;i++){
                bids[bidders[i]].bid_price = temp_price;
            }
        }
    }
    
    function Bidder_send_ether_owner() public payable returns(bool){
        
                
        uint price = bids[winner_bidders[winner_bidders.length-1]].bid_price;
        require(bids[msg.sender].bid_placed,"caller not placed any bid");
        require(bids[msg.sender].bid_accepted,"bid not accepted");
        require(bids[msg.sender].bid_price_transfer == false,"money already transferred");
        require(msg.value >= (price)*(bids[msg.sender].bid_quantity),"sending less ether");
        
        bool transferred = payable(owner).send(msg.value);
        require(transferred == true,"ether transfer error");
        bids[msg.sender].bid_price_transfer = true;
        return true;
    }
    
    function Auction_Owner_transfer_tokens(address receiver,uint amount) public returns(bool){
        require(bids[receiver].bid_price_transfer == true,"receiver not transferred money");
        require(bids[receiver].bid_quantity_transfer == false,"tokens already transferred");
        bool token_transfer = questTokens.transfer(receiver,amount);
        require(token_transfer == true,"tokens not transferred");
        bids[receiver].bid_quantity_transfer = true;
        return true;
    }
}
