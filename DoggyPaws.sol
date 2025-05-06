// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Doggypaws is ERC20, Ownable {
    string public logoURI = "https://gateway.pinata.cloud/ipfs/bafybeie4g3ztbztohtlkkkhevofy5mdua463dkqi3bswxfujhch2dnrvfu";

    constructor() ERC20("Doggypaws", "DPS") Ownable(msg.sender) {
        uint256 total = 100_000_000_000_000 * 10 ** decimals(); // 100 trillion

        uint256 burnAmount = (total * 50) / 100; // 50%
        uint256 lpAmount = (total * 35) / 100;   // 35%
        uint256 devAmount = (total * 15) / 100;  // 15%

        // Distribute
        _mint(0x000000000000000000000000000000000000dEaD, burnAmount);         // Burn
        _mint(0xEa85aa515190D1D3D915B107ac4A2091e8E58b0d, lpAmount);           // Liquidity
        _mint(0xEa85aa515190D1D3D915B107ac4A2091e8E58b0d, devAmount);          // Dev
    }

    function renounce() external onlyOwner {
        renounceOwnership();
    }
}

