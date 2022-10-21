pragma solidity ^0.8.5;

import "./util/RandomUtil.sol";
import "./payments/GamePaymentsService.sol";

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

    address payable private commissionHandler;
    address payable private depositHandler;
    address private admin;

    uint256 private commissionPercent;
    uint256 private minBidValue;

    GameSession[] private sessions;
    mapping(uint256 => GameSession) private gameIdToGameSession;
    mapping(uint256 => bool) private gameIdToExists;
    mapping(string => bool) private gameInviteLinkToExists;

    modifier gameSessionIsActive(uint256 sessionId) {
        _ensureGameSessionIsActive(sessionId);
        _;
    }

    modifier senderIsMemberOfGame(uint256 sessionId) {
        _ensureSenderIsMemberOfGame(sessionId);
        _;
    }

    modifier gameSessionExists(uint256 sessionId) {
        _ensureGameSessionExists(sessionId);
        _;
    }

    modifier gameSessionExists(string inviteLink) {
        _ensureGameSessionExists(inviteLink);
        _;
    }

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
    ) external returns (string inviteLink) {
        return "";
    }

    function getGameSessionInfo(
        uint256 sessionId
    ) external gameSessionExists(sessionId) returns (GameSession memory) {
        GameSession memory targetSession = gameIdToGameSession[sessionId];
        targetSession.inviteLink = "";
        return targetSession;
    }

    function commit(
        string memory inviteLink
    ) external  gameSessionExists(inviteLink) returns (uint256 sessionId) {
        return 123;
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

    function getCommissionPercent() external view returns (uint256) {
        return commissionPercent;
    }

    function getMinBidValue() external view returns (uint256) {
        return minBidValue;
    }

    function _ensureGameSessionExists(uint256 sessionId) private view {
        require(gameIdToExists[sessionId], "Target game session doesn't exists");
    }

    function _ensureGameSessionExists(string inviteLink) private view {
        require(gameInviteLinkToExists[inviteLink], "Game session with target invite link doesn't exists");
    }

    function _ensureSenderIsMemberOfGame(uint256 sessionId) private view {
        _ensureGameSessionExists(sessionId);
        GameSession storage gameSession = gameIdToGameSession[sessionId];
        uint playersCount = gameSession.players.length;
        for (int i = 0; i < playersCount; i++) {
            if (gameSession.players[i] == msg.sender) {
                return;
            }
        }
        revert Error("Sender is not member of game");
    }

    function _ensureGameSessionIsActive(uint256 sessionId) private view {
        _ensureGameSessionExists(sessionId);
        GameSession storage gameSession = gameIdToGameSession[sessionId];
        if (gameSession.sessionStatus == GameSessionStatus.Distributed) {
            revert Error("Target game session is not active");
        }
    }
}