pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2;
//import "erc20prperty.sol";


interface Interface_stars {
    
    function transfer(address , uint256) payable external returns(bool);
    function transferFrom(address ,address , uint256) payable external returns(bool) ;
    function balanceOf(address)  external view  returns(uint256);
    function approve(address , uint256) external payable  returns(bool);
    
} 

contract MyProperty {
  
   struct PropertyMetadata {
    uint256 propId;
    address OriginalOwner;
    string location;
    uint256 value;
    uint256 contact;
   }
  
 
   PropertyMetadata[] public prop;
   
   address[] public EligibleEmp;
   address public contractOwner;
   uint256 nftPrice;
   uint256 total_Vouch_supp;
   uint256 public tot_no_of_prop_onplatform = 1;
   

   mapping(address => mapping(uint256 => PropertyMetadata)) public ListedProperty;
   mapping(address => mapping(uint256=>uint256)) public no_Of_Prop_Token;
   mapping(address => mapping(uint256=>uint256)) public assesedTokenValue;
   mapping(address => uint256) public no_Of_Vouch_Token;
   mapping(address => uint256[]) public propIdOwnByOwner;
   
   event propertyListed(address QuestEmp,PropertyMetadata data);
   event showProp(PropertyMetadata);
   event Transfer(address indexed _from,address indexed _to,uint256 _value);
   event prop_token_buy(address buyer,address seller,uint256 _no);
   
   constructor() public{

       EligibleEmp.push(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
       EligibleEmp.push(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
       EligibleEmp.push(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db);
       EligibleEmp.push(0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB);
       nftPrice = 1;
       contractOwner = msg.sender;
       no_Of_Vouch_Token[msg.sender] = 10000;
       total_Vouch_supp = 10000;
   
   }
   
    modifier onlyOwner () {
    require(msg.sender == contractOwner);
    _;
   }
   
   
   /*-----------------------Increase Vocher Token Supply------------------------------*/
   function Inc_Vouch_Supply(uint256 _newSupply) external payable onlyOwner {
    require(_newSupply > 0);   
    no_Of_Vouch_Token[contractOwner] = no_Of_Vouch_Token[contractOwner] + _newSupply;  
    total_Vouch_supp += _newSupply;
   }

   /*-----------------------Decrease Vocher Token Supply------------------------------*/
   function Dec_Vouch_Supply(uint256 _reduceSupply) external payable onlyOwner{
    require(_reduceSupply<=no_Of_Vouch_Token[contractOwner]);
    no_Of_Vouch_Token[contractOwner] = no_Of_Vouch_Token[contractOwner] - _reduceSupply;  
    total_Vouch_supp -= _reduceSupply;
    }


   /*-------------------------Search Employee is legit or not to list property---------------------------*/
   function searchEmp(address QuestEmp) view internal returns(bool){
   for(uint16 i=0;i<EligibleEmp.length;i++){
   if(EligibleEmp[i] == QuestEmp)
   return true;
   }
   return false;
   }


   /*-------------------------Search Owner has property in Quest or not-----------------------------------*/
   function searchOwner(address Owner) view internal returns(bool){
   for(uint256 i=0;i<prop.length;i++){
   if(prop[i].OriginalOwner == Owner)
   return true;
   }
   return false;
  }
      
   
   /*-------------------------Min PropToken to purchase---------------------------*/
  function minToken(address owner,uint256 tokens,uint256 propid) view internal returns(bool){
    uint256 minTok = (tokens*100)/assesedTokenValue[owner][propid];
    if(minTok>=10 && minTok<=100)
    return true;
    return false;
  }
   

   /*-------------------------Owner requests for property tokens---------------------------*/
   function getPropTokens(address owner,uint256 no_of_tokens,uint256 propid) external payable{
       
    if(no_of_tokens>0 && assesedTokenValue[owner][propid] >= no_of_tokens && minToken(owner,no_of_tokens,propid)){
        // erc_prop.transfer(owner,no_of_tokens,propid);
        no_Of_Prop_Token[owner][propid] = no_Of_Prop_Token[owner][propid]+no_of_tokens;
        assesedTokenValue[owner][propid] = assesedTokenValue[owner][propid] - no_of_tokens;
    }
     
   }
   
   
    /*-------------------------Buy Vocher tokens---------------------------*/
    function giveVocherTokens(address receiver,uint256 noOfVoucher) external{
        require(noOfVoucher>10);
          transfer_Vouch_Token(receiver,noOfVoucher);
    }
    
    
    /*-------------------------Eligible QuestEmp can list property---------------------------*/
    function ListProperty(address OrigOwner,string loc,uint256 value,uint256 contact) public returns(bool) {
      
    if(searchEmp(msg.sender)){
      
      PropertyMetadata data;
      data.propId =  tot_no_of_prop_onplatform;
      tot_no_of_prop_onplatform += 1;
      data.OriginalOwner = OrigOwner;
      data.location = loc;
      data.value = value;
      data.contact = contact;
      propIdOwnByOwner[OrigOwner].push(data.propId);
      uint256 ind = prop.push(data) - 1;
      ListedProperty[msg.sender][ind] = data;
      assessedValue(msg.sender,data.value,data.OriginalOwner,data.propId);
      emit propertyListed(msg.sender,data);
      return true;    
    }
    return false;
    }
    
    
  /*-------------------------Quest Employee supply some value to the property---------------------------*/
   function assessedValue(address QuestEmp,uint256 valueProp,address Owner,uint256 propid) internal returns(uint256){
   
    require(valueProp>0);
    assesedTokenValue[Owner][propid] = assesedTokenValue[Owner][propid]+valueProp;
    return assesedTokenValue[Owner][propid];

   }
    
    
  
    /*-------------------------to get all listed properties on platform---------------------------*/
    function getAllListedProp() view external returns(PropertyMetadata[]){
      return prop;
    }
  
    /*-------------------------Filter properties for a specific owner---------------------------*/
    function getAllPropOfOwner() external {
      
      for(uint256 i = 0; i<prop.length ;i++){
          if(prop[i].OriginalOwner == msg.sender)
          {
              emit showProp(prop[i]);
          }
      }
    }
  
    /*-------------------------Filter Property through specific location---------------------------*/
    function getpropertyByLocation(string loc) external{
     
      for(uint256 i=0;i<prop.length;i++){
          string storage st = prop[i].location;
          if(equal(st,loc)){
          emit showProp(prop[i]);
          }
      }
    }
  
    /*-------------------------Filter Property for specific range---------------------------*/
    function getPropertyByRange(uint256 _low,uint256 _high) external{
        for(uint256 i=0;i<prop.length;i++){
          uint256 currVal = prop[i].value;
          if(currVal>=_low && currVal<=_high){
          
          emit showProp(prop[i]);
          }
      }
    }
    
    
    function transfer_Vouch_Token(address _to, uint256 _value) internal returns (bool) {
        
        require(_value>0);
        require(no_Of_Vouch_Token[msg.sender]>=_value);
        no_Of_Vouch_Token[msg.sender] -= _value;     
        no_Of_Vouch_Token[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function buyPropertyToken(uint256 offerered_vouch_token,address owner_prop_token,uint256 propId) external payable{
        
        require(offerered_vouch_token <= no_Of_Prop_Token[owner_prop_token][propId]);
        require(offerered_vouch_token>0);
        require(no_Of_Vouch_Token[msg.sender]>=offerered_vouch_token);
        
        no_Of_Prop_Token[msg.sender][propId] += offerered_vouch_token;
        no_Of_Prop_Token[owner_prop_token][propId] -= offerered_vouch_token;
        no_Of_Vouch_Token[msg.sender] -= offerered_vouch_token;
        no_Of_Vouch_Token[owner_prop_token] += offerered_vouch_token;
        
        emit prop_token_buy(msg.sender,owner_prop_token,offerered_vouch_token);
    }

    
    function redeem_vouch_token(address _receiver,uint256 _no_of_vouch_redeem) external payable{
        // require(no_Of_Vouch_Token[msg.sender] >= _no_of_vouch_redeem);
        _receiver.transfer(msg.value);
        
    }
    


    /*-------------------------To Compare two strings---------------------------*/
    function compare(string _a, string _b) internal pure returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }

    function equal(string _a, string _b) internal pure returns (bool) {
        return compare(_a, _b) == 0;
    }
   
      
}

