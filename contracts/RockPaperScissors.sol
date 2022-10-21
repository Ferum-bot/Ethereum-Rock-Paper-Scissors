pragma solidity ^0.8.5;

contract RockPaperScissors {

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
        address[] players;
        uint256 bidValue;

        GameSessionStatus sessionStatus;
    }

    event SessionCreated(uint256 id, address author);
    event PlayerCommitted(uint256 sessionId, address player);
    event PlayerRevealed(uint256 sessionId, address player, PlayerChoice choice);
    event GameDistributed(uint256 sessionId, address winner, uint256 profit);

    modifier gameSessionIsActive(uint256 sessionId) {
        _;
    }

    modifier senderIsMemberOfGame(uint256 sessionId) {
        _;
    }

    address payable private commissionHandler;
    address payable private depositHandler;
    address private admin;

    uint256 private commissionPercent;
    uint256 private minBidValue;

    GameSession[] private sessions;
    mapping(uint256 => GameSession) private gameIdToGameSession;
    mapping(uint256 => bool) private gameIdToExists;

    constructor(
        address _commissionHandler,
        address _depositHandler,
        uint256 _commissionPercent,
        uint256 _minBidValue
    ) {
        admin = msg.sender;

        commissionHandler = _commissionHandler;
        depositHandler = _depositHandler;

        commissionPercent = _commissionPercent;
        minBidValue = _minBidValue;
    }

    function createNewSession(
        uint256 bidValue
    ) external {

    }

    function commit(
        uint256 sessionId
    ) external senderIsMemberOfGame(sessionId) gameSessionIsActive(sessionId) {

    }

    function reveal(
        uint256 sessionId,
        PlayerChoice choice
    ) external senderIsMemberOfGame(sessionId) gameSessionIsActive(sessionId) {

    }

    function distributed(
        uint256 sessionId
    ) external senderIsMemberOfGame(sessionId) gameSessionIsActive(sessionId) {

    }
}