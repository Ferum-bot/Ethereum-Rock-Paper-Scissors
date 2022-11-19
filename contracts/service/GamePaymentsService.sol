// SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.5;

import "../tokens/RPS-Token.sol";

contract GamePaymentsService {

    address private owner;

    address private rockPaperScissors;

    address private tokenAddress;
    RPS private token;

    constructor() {
        owner = msg.sender;
    }

    function reserveDeposit(
        address reserveFrom,
        address depositHandler,
        uint256 depositValue
    ) public pure onlyRockPaperScissors {
        token.transferCoins(reserveFrom, depositHandler, depositValue);
    }

    function returnDeposit(
        address returnTo,
        address depositHandler,
        uint256 depositValue
    ) public pure onlyRockPaperScissors {
        token.transferCoins(depositHandler, returnTo, depositValue);
    }

    function payAndTakeCommission(
        address winner,
        uint256 bid,
        address depositHandler,
        address commissionHandler,
        uint256 commissionPercent
    ) public pure onlyRockPaperScissors {
        uint256 commissionAmount = (2 * bid) * commissionPercent / 100;
        uint256 winnerPayment = 2 * bid - commissionAmount;

        token.transferCoins(depositHandler, winner, winnerPayment);
        token.transferCoins(depositHandler, commissionHandler, commissionAmount);
    }

    function getRockPaperScissorsAddress() external view returns (address) {
        return rockPaperScissors;
    }

    function setRockPaperScissorsAddress(address _rockPaperScissors) external onlyOwner {
        rockPaperScissors = _rockPaperScissors;
    }

    function getRPSTokenAddress() external view returns (address) {
        return tokenAddress;
    }

    function setRPSTokenAddress(address _tokenAddress) external onlyOwner {
        tokenAddress = _tokenAddress;
        token = RPS(tokenAddress);
    }

    modifier onlyRockPaperScissors() {
        require(msg.sender == rpsTokenAddress, "Only Rock-Paper-Scissors smart contract can use this functionality");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can use this functionality");
        _;
    }
}