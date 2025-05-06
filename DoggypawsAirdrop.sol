// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract DoggypawsAirdrop {
    IERC20 public token;
    address public owner;

    mapping(address => bool) public hasClaimed;
    mapping(address => uint256) public claimAmounts;

    event AirdropClaimed(address indexed user, uint256 amount);
    event OwnershipRenounced();

    constructor(address _token) {
        token = IERC20(_token);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function claim() external {
        require(!hasClaimed[msg.sender], "Already claimed");

        // Simulated randomness
        uint256 rand = uint256(
            keccak256(abi.encodePacked(msg.sender, block.timestamp, blockhash(block.number - 1)))
        );
        uint256 min = 1_000_000 * 1e18;
        uint256 max = 10_000_000 * 1e18;
        uint256 range = max - min + 1;
        uint256 amount = (rand % range) + min;

        require(token.balanceOf(address(this)) >= amount, "Not enough tokens");

        hasClaimed[msg.sender] = true;
        claimAmounts[msg.sender] = amount;
        token.transfer(msg.sender, amount);

        emit AirdropClaimed(msg.sender, amount);
    }

    function getClaimedAmount(address user) external view returns (uint256) {
        return claimAmounts[user];
    }

    function withdraw(address to, uint256 amount) external onlyOwner {
        token.transfer(to, amount);
    }

    function renounceOwnership() external onlyOwner {
        owner = address(0);
        emit OwnershipRenounced();
    }
}

