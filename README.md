# eth_assessment3

This contract is written in Solidity and implements a decentralized Membership Token System.

## Description

This Smart Contract provides essential functionalities for managing membership tokens on the Ethereum blockchain. It includes features for authorization, token minting, burning resources, transferring tokens from one address to another address, and auditing token transfers.
## Getting Started

### Executing program

Before executing the program you have to download and keep both the ERC20 and Ownable files in the same directory as the MembershipToken solidity file.

To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at https://remix.ethereum.org/.

Once you are on the Remix website, create a new file by clicking on the "+" icon in the left-hand sidebar. Save the file with a .sol extension (e.g., membership.sol). Copy and paste the following code into the file:

```javascript
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

    function _update(address from, address to, uint256 value) internal virtual override {
        super._update(from, to, value);
        // Emit a detailed transfer event for audit purposes
        emit MembershipTransfer(from, to, value, block.timestamp);
    }

    event MembershipTransfer(address indexed from, address indexed to, uint256 value, uint256 timestamp);
}


```

To compile the code, click on the "Solidity Compiler" tab in the left-hand sidebar. Make sure the "Compiler" option is set to "0.8.20" (or another compatible version), and then click on the "Compile membership.sol" button.

Once the code is compiled, you can deploy the contract by clicking on the "Deploy & Run Transactions" tab in the left-hand sidebar. Select the "MembershipToken" contract from the dropdown menu, and then click on the "Deploy" button.

After deploying the `MembershipToken` contract on Ethereum, you can manage membership tokens with clear governance and transparency. Begin by authorizing issuers who can mint tokens using `authorizeIssuer`. Once authorized, these issuers can mint tokens for recipients with `issueMembership`. To maintain control, revoke issuer permissions with `revokeIssuer`, and allow token holders to reduce their holdings using `burn`. Use the `transfer` and `transferFrom` function to transfer tokens from one address to another. Every token transfer triggers a `MembershipTransfer` event, logging sender, recipient, amount, and timestamp for auditability. Integrate this contract to efficiently manage memberships, ensuring secure and accountable token operations on the blockchain.
## Authors

Yukta
[@Chandigarh University](https://www.linkedin.com/in/yukta-/)


## License

This project is licensed under the MIT License - see the LICENSE.md file for details
