// SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.5;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract RPS is ERC20 {

    address private owner;

    address private rpsGamePaymentsService;

    uint256 private donation;

    uint256 private timeLockDuration;
    mapping(address => uint256) lastTimeTokensTaken;

    constructor (
        uint256 _timeLockDuration,
        uint256 _donation
    ) ERC20("RockPaperScissorsToken", "RPC") {
        owner = msg.sender;
        timeLockDuration = _timeLockDuration;
        donation = _donation;

        _mint(owner, 10000 * 10 ** decimals());
    }

    function transferCoins(address from, address to, uint256 amount) external onlyRPSGamePaymentsService {
        _transfer(from, to, amount);
    }

    function takeFreeCoins() external lockDurationPassed {
        _transfer(owner, msg.sender, donation);
    }

    function setTimeLockDuration(uint256 _timeLockDuration) external onlyOwner {
        timeLockDuration = _timeLockDuration;
    }

    function getTimeLockDuration() view external returns (uint256) {
        return timeLockDuration;
    }

    function setDonation(uint256 _donation) external onlyOwner {
        donation = _donation;
    }

    function getDonation() external view returns (uint256) {
        return donation;
    }

    function getRPSGamePaymentsServiceAddress() view external returns (address) {
        return rpsGamePaymentsService;
    }

    function setRPSGamePaymentsServiceAddress(address _rpsGamePaymentsService) external onlyOwner {
        rpsGamePaymentsService = _rpsGamePaymentsService;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can use this functionality");
        _;
    }

    modifier onlyRPSGamePaymentsService() {
        require(msg.sender == rpsGamePaymentsService, "Only Rock-Paper-Scissors can use this functionality");
        _;
    }

    modifier lockDurationPassed() {
        uint256 timePassed = now() - timeLockDuration[msg.sender];
        require(timePassed >= timeLockDuration, "Time lock duration not passed");
        _;
    }
}