// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./ERC721.sol";
import "./ERC20.sol";



contract Property is ERC721 {
  string[] public properties;
  address public proptest;
  mapping(string => bool) _propertyExists;
  
  struct property_Details{
      string name;
      address deployed_Token;
  }
  property_Details[] public property_Array;

  constructor() ERC721("Property","QST_TKN") public{
      
  }
  
      event TokenCreated(address tokenAddress);
  function mint(string memory _property,uint256 origVal,
                                     uint256 coins,
                                     string memory property_images_hash,
                                     string[] memory pro_add_details,
                                     uint256 prop_tax,
                                     uint256 prop_insurance,
                                     uint256 prop_maintainence,
                                     string memory features_prop) public {
   require(!_propertyExists[_property]);
   property_Details memory temp;
   properties.push(_property);
   // uint _id = properties.length; 
    
   _mint(origVal,coins,property_images_hash,pro_add_details,prop_tax,prop_insurance,prop_maintainence,features_prop);
   _propertyExists[_property] = true;

   temp.name = _property;
   temp.deployed_Token = deployNewToken("prop1", "QST",origVal);

    deployNewToken("VOUCHER","*V*",origVal);
    
   property_Array.push(temp);
   delete temp;
    
  } 
  
  function deployNewToken(string memory name, string memory symbol,uint256 no_of_token) public returns (address) {
       ERC20 t = new ERC20( name, symbol,msg.sender,no_of_token);
       proptest = address(t);
       emit TokenCreated(address(t));
       return proptest;
       
   }
   
   
  
  

  function getProperties(uint _index) public view returns(string memory){
   
  return properties[_index];
  
} 

function totalProperties()public view returns(uint256){
    
    return properties.length;
}
    

}

