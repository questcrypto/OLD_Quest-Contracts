// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./IERC721.sol";
import "./IERC20.sol";
import "./ERC20.sol";
import "./Strings.sol";

contract Property {
    
  using Strings for string; 
  
  
  /*--------------------------------------------------Interface to Other Contracts-----------------------------------*/
  
  IERC721 PropertyNFT;
  IERC20 UtilityTokens;
  
  /*----------------------------------------------Interface Declaration End----------------------------------------*/
  
  
  
  /*-----------------------------------------------------Variables-------------------------------------------------*/
  
  string[] public properties;
  address public proptest;
  address public contractowner;
  address public marketAddress;
 
 /*-----------------------------------------------Variable Declaration End---------------------------------------*/
 
 
 
 /*---------------------------------------------------Mappings---------------------------------------------------*/
  
  mapping(string => bool) _propertyExists;
  mapping(address => bool) public _authorizedAccounts;
  mapping(uint256 => address) public Prop_token_deploy_address;
  mapping(address => string[]) public OwnedProperties;
  
  /*-----------------------------------------------Mappings End------------------------------------------------*/
  
  
  
  /*-------------------------------------------------Events------------------------------------------------*/
  
  event TokenCreated(address tokenAddress);

  /*-------------------------------------------------------------------------------------------------------*/
  
  
  constructor(address ERC20contractAddress, address ERC721ContractAddress)  public{
      
    _authorizedAccounts[msg.sender] = true;
    PropertyNFT = IERC721(ERC721ContractAddress);
    UtilityTokens = IERC20(ERC20contractAddress);
    contractowner = msg.sender;
  }
   
  modifier onlyOwner() {
    require(msg.sender == contractowner);
    _;
  }
  
  //Set MArket Contract Deployed Address
  function setMarketAddress(address _address) public onlyOwner {
    marketAddress = _address;
  }
    
  //List Property to Quest Platform and mint tokens
  function mint(string memory _property,
                uint256 origVal,
                uint256 coins,
                string[] memory property_images,
                string[] memory pro_add_details,
                uint256 prop_tax,
                uint256 prop_insurance,
                uint256 prop_maintainence,
                string memory features_prop) public {
    
    _property = _property._toLower();                                     
    require(!_propertyExists[_property],"Property Already Minted");
    require(_authorizedAccounts[msg.sender], "Unauthorized Account");
    require(origVal >= coins, "Invalid Input");
    properties.push(_property);
    
    //Mint NFT TOKEN for Property
    PropertyNFT._mint(msg.sender,origVal,coins,property_images,pro_add_details,prop_tax,prop_insurance,prop_maintainence,features_prop);
    
    _propertyExists[_property] = true;
    OwnedProperties[msg.sender].push(_property);
    
    //Generate ERC20 Property Tokens 
    deployNewToken(_property, "QST",origVal,totalProperties());
    
    //Generate ERC20 Voucher or Quest Tokens
    IncreaseUtilityTokenSupply(origVal);
                                         
   } 

  
  function deployNewToken(string memory name, string memory symbol,uint256 no_of_token,uint property_id) internal returns (address) {
   
    ERC20 QuestEquity = new ERC20( name, symbol);
    Prop_token_deploy_address[property_id] = address(QuestEquity);
    QuestEquity.issuetoken(msg.sender,no_of_token);
    QuestEquity.setMarketAddress(marketAddress);
    emit TokenCreated(address(QuestEquity));
    return address(QuestEquity);
       
  }
  
  function IncreaseUtilityTokenSupply(uint256 no_of_token) internal  {
  
    UtilityTokens.issuetoken(msg.sender,no_of_token);
       
  }
  
  
  function PropertyTokenBalance(address user,uint256 property_id) public view returns(uint256){
       
    IERC20 erc_property;
    erc_property = IERC20(Prop_token_deploy_address[property_id]);
    return erc_property.balanceOf(user);
  
  }


  /*-------------------------Search Property belongs to caller or not---------------------------*/
function searchPropertyOwner(address property_owner,string memory property_name) view public returns(bool){
   
  for(uint256 i=0;i<OwnedProperties[property_owner].length;i++){
   
    if((OwnedProperties[property_owner][i]).equal(property_name))
    return true;
   
  }
  return false;
   
}


  function getOwnerProperties(address owner) public view returns(string[] memory){
       return OwnedProperties[owner];
  }
  
  
  function addProperties(address buyer,string memory property_name) public{
     require(msg.sender == marketAddress);
     OwnedProperties[buyer].push(property_name);
} 


  function getProperties(uint _index) public view returns(string memory){
   
  return properties[_index];
  
}

    function totalProperties()public view returns(uint256){
    uint256 len = properties.length;
    
    return len;
    
}
    
    

}
