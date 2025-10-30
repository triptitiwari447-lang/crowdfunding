// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfund {
    address public owner;
    uint256 public goal;
    uint256 public totalFunds;

    mapping(address => uint256) public contributions;

    constructor(uint256 _goal) {
        owner = msg.sender;
        goal = _goal;
    }

    // 1️⃣ Function to contribute ETH to the crowdfunding campaign
    function contribute() external payable {
        require(msg.value > 0, "You must send ETH to contribute");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;
    }

    // 2️⃣ Function for owner to withdraw funds once the goal is reached
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= goal, "Goal not reached yet");
        payable(owner).transfer(address(this).balance);
    }
}

