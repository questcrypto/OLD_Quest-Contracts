// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./ERC721.sol";


contract Property is ERC721 {
  string[] public properties;
  mapping(string => bool) _propertyExists;

  constructor() ERC721("Property", "QST_NFT") public {
  }
  
  function mint(string memory _property) public {
   require(!_propertyExists[_property]);
    properties.push(_property);
    uint _id = properties.length;
    _mint(msg.sender,_id);
    _propertyExists[_property] = true;
    
  } 


   function getProperties(uint _index) public view returns(string memory){
  return properties[_index];
}
 
}


