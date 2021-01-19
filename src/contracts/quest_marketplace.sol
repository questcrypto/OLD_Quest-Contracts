// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);
    
    function SellerOrBuyerApproveMarket (address owner, address spender, uint256 amount) external;

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    function issuetoken(address account, uint256 amount) external;
    
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface Property{
    
    function searchPropertyOwner(address,string memory) external returns(bool);
    
    function properties(uint256) external returns(string memory);
    
    function Prop_token_deploy_address(uint256) external returns(address);
    
    function OwnedProperties(address) external returns(string[] memory);
    
    function addProperties(address,string memory) external;
    
    function PropertyTokenBalance(address user,uint256 property_id) external view returns(uint256);
    
}

contract MarketPlace {
    
    using Strings for *;
   
    IERC20 erc;
    
    uint256 _id = 0;
    
    Property public _property;

    address public owner_address;
    
    address public __address;

    uint256 total_Properties_tokens_for_sell;
    
    string[]  properties_for_sell;

    mapping(address => mapping(uint256 => token_sell_information)) public token_details;
    
    
    struct token_sell_information {
    
    bool is_available;
    address seller;
    uint256 property_id;
    uint256 quantity;
    
    }
    
    modifier onlyOwner {

    require(msg.sender == owner_address);
    _;

    }

    constructor(address _addressERC,address _addressProperty) public {

        owner_address = msg.sender;
        erc = IERC20(_addressERC);
        _property = Property(_addressProperty);
    }


    //function to purchase voucher/Quest tokens  to puchas property Tokens
    function purchaseVocherTokens(uint256 amount_of_token) public payable{

      require(msg.value>=amount_of_token);
      erc.issuetoken(msg.sender,amount_of_token);

    }

    //function to sell property tokens of particular property_id
    function sellPropertyToken(uint256 property_id,uint256 quantity) public payable{
      
      require(property_id>0 && quantity>0);
      string memory property_name = _property.properties(property_id-1);
      require(_property.searchPropertyOwner(msg.sender,property_name),"not found");
      require(quantity<=_property.PropertyTokenBalance(msg.sender,property_id),"not enough fund");
      
      token_sell_information memory  temp;
      temp.is_available = true;
      temp.seller = msg.sender;
      temp.property_id =property_id;
           
      if(token_details[msg.sender][property_id].quantity != 0){
         temp.quantity = token_details[msg.sender][property_id].quantity + quantity;
      }
      
      else{
         temp.quantity = quantity;
         total_Properties_tokens_for_sell++;
         address temp_Ad = msg.sender;
         string memory prop_owner = (temp_Ad).toString();
         string memory prop_id = property_id.uinttoString();
         properties_for_sell.push(string(abi.encodePacked(prop_owner, "!", prop_id)));
      }
      
      IERC20 erc_property;
      erc_property = IERC20(_property.Prop_token_deploy_address(property_id));
      erc_property.SellerOrBuyerApproveMarket(msg.sender,address(this),quantity);
      
      token_details[msg.sender][property_id] = temp;
      
          
      delete temp.is_available;
      delete temp.seller;
      delete temp.property_id;
      delete temp.quantity;
      delete property_name;
      
    }
    
    //Revoke Property Tokens From Selling
    function revokePropertyTokensFromSelling(uint property_id,uint quantity) public payable{
        
        require(property_id>0 && quantity>0);
        string memory property_name = _property.properties(property_id-1);
        require(_property.searchPropertyOwner(msg.sender,property_name),"not found");
        require(quantity <= token_details[msg.sender][property_id].quantity,"given quantity exceeds the quantity availaible to sell");
                
      
        if(token_details[msg.sender][property_id].quantity != 0){
            if(quantity == token_details[msg.sender][property_id].quantity){
             //cancel market approval   
              IERC20 erc_property;
              erc_property = IERC20(_property.Prop_token_deploy_address(property_id));
              erc_property.SellerOrBuyerApproveMarket(msg.sender,address(this),0);
              delete token_details[msg.sender][property_id];
              
              total_Properties_tokens_for_sell--;
              string memory temp = string(abi.encodePacked(msg.sender, "!", property_id));
              
              for(uint256 i = 0;i<properties_for_sell.length;i++){
                 if(properties_for_sell[i].equal(temp)){
                    properties_for_sell[i] = "";
                    break;
                 }
              }
              
            }
            else{
             //decrease the quantity availaible for selling
             token_details[msg.sender][property_id].quantity -= quantity;
            }
        }
    }
  
    //function to buy property tokens availaible for selling
    function purchasePropertyTokens(uint voucher_token_offered,address property_token_owner,uint property_id) public payable{
      
      require(token_details[property_token_owner][property_id].quantity >= voucher_token_offered);
      require(getVoucherBalance(msg.sender)>=voucher_token_offered);
      
      IERC20 erc_property;
      erc_property = IERC20(_property.Prop_token_deploy_address(property_id));
      require(voucher_token_offered <= _property.PropertyTokenBalance(property_token_owner,property_id));
      
      erc.SellerOrBuyerApproveMarket(msg.sender,address(this),voucher_token_offered);
      erc.transferFrom(msg.sender,property_token_owner,voucher_token_offered);        
      erc_property.transferFrom(property_token_owner,msg.sender,voucher_token_offered);
      
      _property.addProperties(msg.sender,_property.properties(property_id-1));
      token_details[property_token_owner][property_id].quantity -= voucher_token_offered;
      

    
      if(token_details[property_token_owner][property_id].quantity == 0)
      {
      total_Properties_tokens_for_sell--;
      delete token_details[property_token_owner][property_id];
      string memory temp = string(abi.encodePacked(property_token_owner, "!", property_id));
      for(uint256 i = 0;i<properties_for_sell.length;i++){
            if(properties_for_sell[i].equal(temp)){
                properties_for_sell[i] = "";
                break;
            }
        }
      }
   
    }
    
    

  
    //function to check how many voucher tokens user holds
    function getVoucherBalance(address user) public view returns(uint256){
      return erc.balanceOf(user);
    }
  
    //function to check how many property tokens of a particular property user holds
    function getPropertyTokenBalance(address user,uint256 property_id) public view returns(uint256){
       return _property.PropertyTokenBalance(user,property_id);
    }
    
    function showAvailableTokenForSelling() public view returns (string[] memory available){
        // returns the array of token present in marketplace
        string[] memory available_token_for_sell = new string[](total_Properties_tokens_for_sell);
        uint256 j;
        for (uint256 i = 0; i < properties_for_sell.length; i++) {
            if (properties_for_sell[i].equal("")){
                //do nothing
            } 
            else{
                
                available_token_for_sell[j] = properties_for_sell[i];
                j++;
            }
        }
        return available_token_for_sell;
    }
    

}


library Strings {
   
function _toLower(string memory str) public pure returns (string memory) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            // Uppercase character...
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                // So we add 32 to make it lowercase
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }
    function uinttoString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        uint256 index = digits - 1;
        temp = value;
        while (temp != 0) {
            buffer[index--] = byte(uint8(48 + temp % 10));
            temp /= 10;
        }
        return string(buffer);
    }
     /*-------------------------To Compare two strings---------------------------*/
    function compare(string memory  _a, string memory _b) internal pure returns (int) {
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

    function equal(string memory _a, string memory _b) internal pure returns (bool) {
        return compare(_a, _b) == 0;
    }
   function toString(address account) public pure returns(string memory) {
    return toString(abi.encodePacked(account));
}

function toString(uint256 value) public pure returns(string memory) {
    return toString(abi.encodePacked(value));
}

function toString(bytes32 value) public pure returns(string memory) {
    return toString(abi.encodePacked(value));
}

function toString(bytes memory data) public pure returns(string memory) {
    bytes memory alphabet = "0123456789abcdef";

    bytes memory str = new bytes(2 + data.length * 2);
    str[0] = "0";
    str[1] = "x";
    for (uint i = 0; i < data.length; i++) {
        str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
        str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
    }
    return string(str);
}
}
