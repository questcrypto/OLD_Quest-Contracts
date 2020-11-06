
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./ERC20.sol";

 contract QuestToken is ERC20 {
    address public owner;

    constructor() ERC20("QUEST","%QT%",0xDB3D49B8f3D35902901311e573de3194c7DCf477,18000000000000000000000) public
    {
        owner = msg.sender;
    }
    
        modifier onlyOwner () {
    require(msg.sender == owner);
    _;
   }

    function mint(address recipient, uint256 amount) public onlyOwner {
        require(msg.sender == owner);
        require(_totalSupply + amount >= _totalSupply); // Overflow check

        _totalSupply += amount;
        _balances[recipient] += amount;
        emit Transfer(address(0), recipient, amount);
    }

    function burn(uint256 amount) public onlyOwner {
        require(amount <= _balances[msg.sender]);

        _totalSupply -= amount;
        _balances[msg.sender] -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    function burnFrom(address from, uint256 amount) public onlyOwner {
        require(amount <= _balances[from]);
        require(amount <= _allowances[from][msg.sender]);

        _totalSupply -= amount;
        _balances[from] -= amount;
        _allowances[from][msg.sender] -= amount;
        emit Transfer(from, address(0), amount);
    }
}





























