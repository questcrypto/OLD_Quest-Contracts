// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./ERC721.sol";
import "./ERC20.sol";

contract Property is ERC721 {
  string[] public properties;
  address public proptest;
  mapping(string => bool) _propertyExists;
  

  constructor() ERC721("Property","QST_TKN") public{
      
  }
  
      event TokenCreated(address tokenAddress);
  function mint(string memory _property,uint256 origVal,
                                     uint256 coins,
                                     string[] memory property_images,
                                     string[] memory pro_add_details,
                                     uint256 prop_tax,
                                     uint256 prop_insurance,
                                     uint256 prop_maintainence,
                                     string memory features_prop) public {
   require(!_propertyExists[_property]);
    properties.push(_property);
    // uint _id = properties.length; 
    
    _mint(origVal,coins,property_images,pro_add_details,prop_tax,prop_insurance,prop_maintainence,features_prop);
    _propertyExists[_property] = true;
    
    
    deployNewToken("prop1", "QST");
     
  } 
  
  function deployNewToken(string memory name, string memory symbol) public returns (address) {
       ERC20 t = new ERC20( name, symbol, msg.sender,10000);
       proptest = address(t);
       emit TokenCreated(address(t));
       
   } 
  
  

  function getProperties(uint _index) public view returns(string memory){
   
  return properties[_index];
  
} 

    function totalProperties()public view returns(uint256){
    uint256 len = properties.length;
    return len;
}
    

} 

