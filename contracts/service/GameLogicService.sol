pragma solidity ^0.8.5;

import "../util/GameTypes.sol";

library GameLogicService {

    string constant private INVALID_PLAYER_CHOICE = "Invalid player choice.";

    function getGameWinner(
        address firstPlayer,
        GameTypes.PlayerChoice firstChoice,
        address secondPlayer,
        GameTypes.PlayerChoice secondChoice
    ) public pure returns (address winner, address looser) {

        if (firstChoice == GameTypes.PlayerChoice.Rock) {
            if (secondChoice == GameTypes.PlayerChoice.Rock) {
                return (0, 0);
            }
            if (secondChoice == GameTypes.PlayerChoice.Paper) {
                return (secondPlayer, firstPlayer);
            }
            if (secondChoice == GameTypes.PlayerChoice.Scissors) {
                return (firstPlayer, secondPlayer);
            }

            revert(INVALID_PLAYER_CHOICE);
        }

        if (firstChoice == GameTypes.PlayerChoice.Paper) {
            if (secondChoice == GameTypes.PlayerChoice.Rock) {
                return (firstPlayer, secondPlayer);
            }
            if (secondChoice == GameTypes.PlayerChoice.Paper) {
                return (0, 0);
            }
            if (secondChoice == GameTypes.PlayerChoice.Scissors) {
                return (secondPlayer, firstPlayer);
            }

            revert(INVALID_PLAYER_CHOICE);
        }

        if (firstChoice == GameTypes.PlayerChoice.Scissors) {
            if (secondChoice == GameTypes.PlayerChoice.Rock) {
                return (secondPlayer, firstPlayer);
            }
            if (secondChoice == GameTypes.PlayerChoice.Paper) {
                return (firstPlayer, secondPlayer);
            }
            if (secondChoice == GameTypes.PlayerChoice.Scissors) {
                return (0, 0);
            }

            revert(INVALID_PLAYER_CHOICE);
        }

        revert(INVALID_PLAYER_CHOICE);
    }
}