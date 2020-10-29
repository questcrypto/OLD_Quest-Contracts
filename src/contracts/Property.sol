// SPDX-License-Identifier: MIT

pragma solidity ^0.6.2;

import "./ERC20.sol";



contract Factory {
    event TokenCreated(address tokenAddress);

    function deployNewToken(string memory name, string memory symbol, address issuer,uint256 no_of_tokens) 
    public returns (address) {
        ERC20 t = new ERC20(name, symbol, issuer ,no_of_tokens);
        emit TokenCreated(address(t));
        return address(t);
    }
}