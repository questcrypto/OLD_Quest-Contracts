// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./ERC20.sol";
import "./Strings.sol";
import "./IERC721.sol";
import "./IERC20.sol";
contract Property {
  ERC20 erc20property;
  ERC20 erc20voucher;
  IERC721 nft;
  IERC20 erc;
  
  using Strings for string; 
  string[] properties;  //store all enlisted properties name
  mapping(string => bool) _propertyExists;
  mapping(address => string[]) OwnedProperties;
  mapping(address => mapping(uint256 => ERC20)) public token_prop;
  struct property_Details{
      string name;
      address deployed_Token;
  }
  property_Details[] public property_Array;

  constructor(address deployed_erc721,address deployed_erc20)  public{
      nft = IERC721(deployed_erc721);
      erc = IERC20(deployed_erc20);
  }
  
      event TokenCreated(address tokenAddress);
  function mint(string memory _property,
                                     uint256 origVal,
                                     uint256 coins,
                                     string memory property_images_hash,
                                     string[] memory pro_add_details,
                                     uint256 prop_tax,
                                     uint256 prop_insurance,
                                     uint256 prop_maintainence,
                                     string memory features_prop) public {
   _property = _property._toLower();                                         
   require(!_propertyExists[_property]);
   property_Details memory temp;
   properties.push(_property);
   nft._mint(origVal,msg.sender,coins,property_images_hash,pro_add_details,prop_tax,prop_insurance,prop_maintainence,features_prop);
   _propertyExists[_property] = true;
   OwnedProperties[msg.sender].push(_property);
   temp.name = _property;
   temp.deployed_Token = deployNewToken("prop1", "QST",origVal,totalProperties());
   
   origVal = (85*origVal)/100;
   deployNewVoucherToken(origVal);
    
   property_Array.push(temp);
   delete temp;
    
  } 
  
  function deployNewToken(string memory name, string memory symbol,uint256 no_of_token,uint property_id) internal returns (address) {
       erc20property = new ERC20( name, symbol);
       token_prop[msg.sender][property_id] = erc20property;
       erc20property.issuetoken(msg.sender,no_of_token);
       emit TokenCreated(address(erc20property));
       return address(erc20property);
       
  }
  function deployNewVoucherToken(uint256 no_of_token) internal {
       erc.issuetoken(msg.sender,no_of_token);   
  }
  
  function purchaseVocherTokens(uint256 amount_of_token) public payable{
      require(msg.value>=amount_of_token*10);
      erc.issuetoken(msg.sender,amount_of_token);
  }
  
  
  function purchasePropertyTokens(uint voucher_token_offered,address property_token_owner,uint property_id) public {
      require(getVoucherBalance(msg.sender)>=voucher_token_offered);
      ERC20 _erc20_property_token_instance = token_prop[property_token_owner][property_id];
      require(voucher_token_offered <= _erc20_property_token_instance._balances(property_token_owner));
      erc.transfer(msg.sender,property_token_owner,voucher_token_offered);
      _erc20_property_token_instance.transfer(property_token_owner,msg.sender,voucher_token_offered);
      OwnedProperties[msg.sender].push(properties[property_id-1]);
       token_prop[msg.sender][property_id] = _erc20_property_token_instance;
      
  }
  
  function getVoucherBalance(address user) public view returns(uint256){
      return erc.balanceOf(user);
  }
  
  function getPropertyTokenBalance(address user) public view returns(uint256){
      return erc20property._balances(user);
  }
   
   
  function getOwnerProperties(address owner) public view returns(string[] memory){
       return OwnedProperties[owner];
  }
   
   
  function getProperties(uint _index) public view returns(string memory){
   
  return properties[_index];
  
  } 

  function totalProperties()public view returns(uint256){
    
    return properties.length;
  }
    

}

