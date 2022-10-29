// SPDX-License-Identifier: 0BSD
pragma solidity ^0.8.5;

library GameTypes {

    enum PlayerChoice {
        None,
        Rock,
        Paper,
        Scissors
    }

    enum GameSessionStatus {
        OneCommit,
        TwoCommit,
        OneReveal,
        TwoReveal,
        Distributed
    }

    struct GameSession {
        uint256 id;
        string inviteLink;
        address firstPlayer;
        address secondPlayer;
        uint256 bidValue;

        GameSessionStatus sessionStatus;

        PlayerChoice firstPlayerReveal;
        PlayerChoice secondPlayerReveal;
    }
}