pragma solidity ^0.8.5;

library GameTypes {

    enum PlayerChoice {
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

    struct PlayerReveal {
        address playerAddress;
        PlayerChoice choice;
    }

    struct GameSession {
        uint256 id;
        string inviteLink;
        address[] players;
        uint256 bidValue;

        GameSessionStatus sessionStatus;

        mapping(uint256 => PlayerReveal) reveals;
        uint256 revealsLength;
    }
}