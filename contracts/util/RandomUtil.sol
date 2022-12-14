// SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.5;

import "@openzeppelin/contracts/utils/Strings.sol";

library RandomUtil {

    function getRandomString(
        uint256 blockHash
    ) public pure returns (string memory) {
        uint256 rand = uint(keccak256(abi.encodePacked(blockHash)));
        return Strings.toString(rand);
    }

    function getUniqueIdentifier(uint256 randomValue) public pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(randomValue)));
    }
}