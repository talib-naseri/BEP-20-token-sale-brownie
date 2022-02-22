// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MUNToken is ERC20 {
    constructor(uint256 initialSupply, address saleAccount)
        ERC20("Munzi", "MUN")
    {
        _mint(msg.sender, (initialSupply * 60) / 100);
        _mint(saleAccount, (initialSupply * 40) / 100);
    }
}
