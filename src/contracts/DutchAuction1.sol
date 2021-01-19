// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
contract dutchAuction{
 
    address ownerAddress;
    uint256 public auctionNumber;
    mapping(uint256 => uint256) public currentBidAmount;
    mapping(uint256 => uint256) public LP;
    mapping(uint256 => uint256)  RP;
    mapping(uint256 => bool)    public isAuctionStarted;
    mapping(uint256 => uint256) public auctionType;
    mapping(address => uint256) public locker;                                  //Lock the quest coins of bidder..
    mapping(uint256 => uint256) public RemainingTokens;                         /////  remaining tokens in current auction.. 
    mapping(uint256 => address) public beneficiary;
    mapping(uint256 => bool)    public isAuctionEnd;
    mapping(uint256 => uint256) public auctionEndTime;
    mapping(address => mapping(uint256 => uint256)) bidder;           //bidder address => auction number => number of tokens ...
    mapping(uint256 => address[]) public bidderArray ;
    mapping(uint256 => address) public tokenOwner;
    mapping(uint256 => uint256) public lowestbid;
    mapping(uint256 => uint256) public totalBidders;
    address auctionAddress;
    
    constructor() public {
        ownerAddress = msg.sender;
    }
//   AuctionType 1 for open ,2 for reserved and 3 for defined.
    function listForbid(uint256 propertyTokens, uint256 _LP ,uint256 _RP , uint256 _auctionType) public returns(uint256){
        require(msg.value == LP/100);   //or transfer lp/100 quest coins(i.e 1% non refundible)
        RemainingTokens[auctionNumber] = propertyTokens;
        //Approve the auctioneer to use the tokens... 
        auctionType[auctionNumber] = _auctionType;
        LP[auctionNumber] = _LP/propertyTokens;
        RP[auctionNumber] = _RP/propertyTokens;
        auctionNumber+=1;
        tokenOwner[auctionNumber] = msg.sender;
        return auctionNumber-1;
    }
    function StartAuction(uint256 ceiling ,address _beneficiary , uint256 _tokens ,uint256 auctionNumber) public onlyOwner {
        require(RemainingTokens[auctionNumber]>0,"not available for bid");
        isAuctionStarted[auctionNumber]=true;
        beneficiary[auctionNumber] = _beneficiary;
        currentBidAmount[auctionNumber] = ceiling;
        auctionEndTime[auctionNumber] = now + 432000;
      
    }
    function changeBidPrice(uint256 reduceby, uint256 auctionNumber) public onlyOwner{
        require(RemainingTokens[auctionNumber]!=0,"Already have a bidders at current amount");
        require(auctionEndTime[auctionNumber]>=now,"Auction already ended");
        require((currentBidAmount[auctionNumber]-reduceby)>RP[auctionNumber]*RemainingTokens[auctionNumber]);
        currentBidAmount[auctionNumber] -= reduceby;
    }
    function bid(uint256 numberOfTokens,uint256 coins , uint256 auctionNumber) public{
        require(auctionEndTime[auctionNumber]>=now,"Auction already ended");
        require(isAuctionStarted[auctionNumber]);
        require(numberOfTokens<=RemainingTokens[auctionNumber]);
       // require(balanceOf[msg.sender] >= coins);   //check the quest coin balance of caller...
       
        if (auctionType[auctionNumber] == 2){
        require(coins>=(RP[auctionNumber]*numberOfTokens));
         locker[msg.sender] = coins;
         bidder[msg.sender][auctionNumber] = numberOfTokens;
         RemainingTokens[auctionNumber]-=numberOfTokens;
         lowestbid[auctionNumber] = coins/numberOfTokens;
         totalBidders[auctionNumber]+=1;
         bidderArray[auctionNumber].push(msg.sender);
    }
    }
    function currentAskingPrice(uint256 _tokenid) public returns(uint256){
        return(currentBidAmount[_tokenid]);
    }
    function isBidComplete(uint256 auctionNumber) public view returns(bool){
        if(RemainingTokens[auctionNumber] > 0){
            return false;
        }
        else{
            return true;
        }
    }
    
    function calculateCoins(uint256 auctionNumber, uint256 tokencount) public returns(uint256){
        return lowestbid[auctionNumber]*tokencount;
    }
    function auctionEnd(uint256 auctionNumber) public {
        require(now>auctionEndTime[auctionNumber] || RemainingTokens[auctionNumber]>0);
        
        //quest.transferFrom(,auctionAddress,coins); transfer quest from bidder to propertyToken owner...
        //not completed
        for(uint256 i = 0 ; i<bidderArray[auctionNumber].length; i++){
            address temp;
            temp=bidderArray[auctionNumber][i];
            uint256 coins=calculateCoins(auctionNumber,bidder[temp][auctionNumber]);
            locker[temp] = coins;
            quest.transferFrom(temp,auctionAddress,coins);   //transfer quest coins from bidder to auction(escrow) address...
            
            transferFrom(tokenOwner[auctionNumber],temp,)
        }
        
    }   
    modifier onlyOwner() {
        require(msg.sender == ownerAddress);
        _;
    }
    
}