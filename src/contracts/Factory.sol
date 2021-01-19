// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


import "./ERC20.sol";
contract Factory {
    event TokenCreated(address tokenAddress);

    function deployNewToken(string memory name, string memory symbol, address issuer) 
    public returns (address) {
        ERC20 t = new ERC20(name, symbol, issuer, 18000000000000000000000);
        emit TokenCreated(address(t));
    }
}