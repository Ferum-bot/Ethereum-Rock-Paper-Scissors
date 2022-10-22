pragma solidity ^0.8.5;

import "../util/GameTypes.sol";

library GameLogicService {

    function getGameWinner(
        address firstPlayer,
        GameTypes.PlayerChoice firstChoice,
        address secondPlayer,
        GameTypes.PlayerChoice secondChoice
    ) public pure returns (address winner, address looser) {

    }
}