// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import ".deps/npm/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import ".deps/npm/@openzeppelin/contracts/access/Ownable.sol";

contract MembershipToken is ERC20, Ownable {
    // Mapping to store authorized issuers
    mapping(address => bool) public authorizedIssuers;

    constructor(string memory name, string memory symbol, address initialOwner) ERC20(name, symbol) Ownable(initialOwner) {}

    // Modifier to restrict function access to authorized issuers only
    modifier onlyAuthorizedIssuer() {
        require(authorizedIssuers[msg.sender], "Not an authorized issuer");
        _;
    }

    // Function to authorize a new issuer
    function authorizeIssuer(address issuer) public onlyOwner {
        authorizedIssuers[issuer] = true;
    }

    // Function to revoke an issuer's authorization
    function revokeIssuer(address issuer) public onlyOwner {
        authorizedIssuers[issuer] = false;
    }

    // Issue membership tokens to a recipient
    function issueMembership(address to, uint256 amount) public onlyAuthorizedIssuer {
        _mint(to, amount);
    }

    // Function to burn membership tokens (e.g., to revoke membership)
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Override _update to add audit trail
    function _update(address from, address to, uint256 value) internal virtual override {
        super._update(from, to, value);
        // Emit a detailed transfer event for audit purposes
        emit MembershipTransfer(from, to, value, block.timestamp);
    }

    // Event to log membership transfer details
    event MembershipTransfer(address indexed from, address indexed to, uint256 value, uint256 timestamp);
}
