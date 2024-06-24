// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MembershipToken is ERC20, Ownable {
    mapping(address => bool) public authorizedIssuers;

    constructor(string memory name, string memory symbol, address initialOwner) ERC20(name, symbol) Ownable(initialOwner) {}

    
    modifier onlyAuthorizedIssuer() {
        require(authorizedIssuers[msg.sender], "Not an authorized issuer");
        _;
    }

    function authorizeIssuer(address issuer) public onlyOwner {
        authorizedIssuers[issuer] = true;
    }

    function revokeIssuer(address issuer) public onlyOwner {
        authorizedIssuers[issuer] = false;
    }

    function issueMembership(address to, uint256 amount) public onlyAuthorizedIssuer {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        bool success = super.transfer(recipient, amount);
        if (success) {
            emit MembershipTransfer(msg.sender, recipient, amount, block.timestamp);
        }
        return success;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        bool success = super.transferFrom(sender, recipient, amount);
        if (success) {
            emit MembershipTransfer(sender, recipient, amount, block.timestamp);
        }
        return success;
    }

    event MembershipTransfer(address indexed from, address indexed to, uint256 value, uint256 timestamp);
}
