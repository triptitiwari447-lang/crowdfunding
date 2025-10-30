// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public owner;
    uint256 public fundingGoal;
    uint256 public totalFunds;
    bool public goalReached;

    mapping(address => uint256) public contributions;

    constructor(uint256 _goal) {
        owner = msg.sender;
        fundingGoal = _goal;
    }

    // 1️⃣ Contribute ETH to the crowdfunding campaign
    function contribute() external payable {
        require(msg.value > 0, "You must send ETH to contribute");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        if (totalFunds >= fundingGoal) {
            goalReached = true;
        }
    }

    // 2️⃣ Owner withdraws funds if goal is reached
    function withdrawFunds() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(goalReached, "Funding goal not reached yet");
        payable(owner).transfer(address(this).balance);
    }

    // 3️⃣ View current balance of the contract
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // 4️⃣ View the contribution made by a specific address
    function getContribution(address contributor) external view returns (uint256) {
        return contributions[contributor];
    }

    // 5️⃣ Refund function — contributors can withdraw if goal not met
    function refund() external {
        require(!goalReached, "Goal was reached, refund not available");
        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No funds to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
