pragma solidity ^0.8.5;

library GamePaymentsService {

    function reserveDeposit(
        address payable reserveFrom,
        address payable depositHandler,
        uint256 depositValue
    ) public pure {

    }

    function returnDeposit(
        address payable returnTo,
        address payable depositHandler,
        uint256 depositValue
    ) public pure {

    }

    function payAndTakeCommission(
        address payable winner,
        uint256 bid,
        address payable depositHandler,
        address payable commissionHandler,
        uint256 commissionPercent
    ) public pure {

    }

    function _transferCoins(
        address payable from,
        address payable to,
        uint256 value
    ) private pure {

    }
}