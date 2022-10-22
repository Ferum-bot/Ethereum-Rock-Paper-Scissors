pragma solidity ^0.8.5;

import "./util/RandomUtil.sol";
import "./util/GameTypes.sol";
import "./service/GamePaymentsService.sol";
import "./service/GameLogicService.sol";

contract RockPaperScissors {

    event SessionCreated(uint256 id, address author);
    event PlayerCommitted(uint256 sessionId, address player);
    event PlayerRevealed(uint256 sessionId, address player);
    event GameDistributed(uint256 sessionId, address winner);

    address payable private commissionHandler;
    address payable private depositHandler;
    address private admin;

    uint256 private commissionPercent;
    uint256 private minBidValue;

    GameTypes.GameSession[] private sessions;
    mapping(uint256 => GameTypes.GameSession) private gameIdToGameSession;
    mapping(string => GameTypes.GameSession) private gameInviteLinkToSession;
    mapping(uint256 => bool) private gameIdToExists;
    mapping(string => bool) private gameInviteLinkToExists;

    modifier gameSessionIsActive(uint256 sessionId) {
        _ensureGameSessionIsActive(sessionId);
        _;
    }

    modifier gameSessionIsActive(string inviteLink) {
        _ensureGameSessionIsActive(inviteLink);
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

    function getGameSessionInfo(
        uint256 sessionId
    ) external gameSessionExists(sessionId) returns (GameTypes.GameSession memory) {
        GameTypes.GameSession memory targetSession = gameIdToGameSession[sessionId];
        if (targetSession.sessionStatus != GameSessionStatus.Distributed) {
            revert Error("Game session is not distributed.");
        }
        return targetSession;
    }

    function createNewSession(
        uint256 bidValue,
        uint256 randomValue
    ) external returns (string memory inviteLink) {
        GameTypes.GameSession memory gameSession;

        string memory inviteLink = RandomUtil.getRandomString();
        uint256 sessionId = RandomUtil.getUniqueIdentifier(randomValue);

        if (gameInviteLinkToExists[inviteLink]) {
            revert Error("Failed to create invitation link. Please try again.");
        }
        if (gameIdToExists[sessionId]) {
            revert Error("Failed to create game session. Please try with another random value.");
        }

        gameSession.id = sessionId;
        gameSession.inviteLink = inviteLink;
        gameSession.bidValue = bidValue;
        gameSession.players.push(msg.sender);
        gameSession.sessionStatus = GameSessionStatus.OneCommit;

        GamePaymentsService.reserveDeposit(msg.sender, depositHandler, bidValue);

        sessions.push(gameSession);

        gameIdToExists[gameSession.id] = true;
        gameInviteLinkToExists[gameSession.inviteLink] = true;
        gameIdToGameSession[gameSession.id] = gameSession;
        gameInviteLinkToSession[gameSession.inviteLink] = gameSession;

        emit SessionCreated(gameSession.id, msg.sender);
        emit PlayerCommitted(gameSession.id, msg.sender);

        return gameSession.inviteLink;
    }

    function commit(
        string memory inviteLink
    ) external gameSessionExists(inviteLink) gameSessionIsActive(inviteLink) returns (uint256 sessionId) {
        GameTypes.GameSession storage targetSession = gameInviteLinkToSession[inviteLink];

        _ensureCommitAllowed(targetSession);

        GamePaymentsService.reserveDeposit(msg.sender, depositHandler, targetSession.bidValue);

        targetSession.players.push(msg.sender);
        targetSession.sessionStatus = GameSessionStatus.TwoCommit;

        emit PlayerCommitted(targetSession.id, msg.sender);

        return targetSession.id;
    }

    function reveal(
        uint256 sessionId,
        GameTypes.PlayerChoice choice
    ) external senderIsMemberOfGame(sessionId) gameSessionIsActive(sessionId) {
        GameTypes.GameSession storage targetSession = gameIdToGameSession[sessionId];

        _ensureRevealAllowed(targetSession);

        GameTypes.PlayerReveal memory reveal;
        reveal.playerAddress = msg.sender;
        reveal.choice = choice;

        targetSession.reveals.push(reveal);

        if (targetSession.sessionStatus == GameSessionStatus.OneReveal) {
            targetSession.sessionStatus = GameSessionStatus.TwoReveal;
        }
        if (targetSession.sessionStatus == GameSessionStatus.TwoCommit) {
            targetSession.sessionStatus = GameSessionStatus.OneReveal;
        }

        emit PlayerRevealed(targetSession.id, msg.sender);
    }

    function distribute(
        uint256 sessionId
    ) external senderIsMemberOfGame(sessionId) gameSessionIsActive(sessionId) returns (address winner, address looser) {
        GameTypes.GameSession storage targetSession = gameIdToGameSession[sessionId];

        _ensureDistributeAllowed(targetSession);

        (address winner, address looser) = GameLogicService.getGameWinner(
            targetSession.reveals[0].playerAddress, targetSession.reveals[0].choice,
            targetSession.reveals[1].playerAddress, targetSession.reveals[1].choice
        );

        GamePaymentsService.payAndTakeCommission(
            winner, targetSession.bidValue,
            depositHandler, commissionHandler,
            commissionPercent
        );

        emit GameDistributed(targetSession.id, winner);

        return (winner, looser);
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

    function _ensureGameSessionExists(string memory inviteLink) private view {
        require(gameInviteLinkToExists[inviteLink], "Game session with target invite link doesn't exists");
    }

    function _ensureSenderIsMemberOfGame(uint256 sessionId) private view {
        _ensureGameSessionExists(sessionId);
        GameTypes.GameSession storage gameSession = gameIdToGameSession[sessionId];
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
        GameTypes.GameSession storage gameSession = gameIdToGameSession[sessionId];
        if (gameSession.sessionStatus == GameSessionStatus.Distributed) {
            revert Error("Target game session is not active");
        }
    }

    function _ensureGameSessionIsActive(string memory inviteLink) private view {
        _ensureGameSessionExists(inviteLink);
        GameTypes.GameSession storage gameSession = gameInviteLinkToSession[inviteLink];
        if (gameSession.sessionStatus ==  GameSessionStatus.Distributed) {
            revert Error("Target game session is not active");
        }
    }

    function _revertDueNotValidGameSessionStatus() private pure {
        revert Error("Action not applied to game session status.");
    }

    function _ensureCommitAllowed(GameTypes.GameSession storage targetSession) private view {
        if (targetSession.sessionStatus != GameSessionStatus.OneCommit) {
            _revertDueNotValidGameSessionStatus();
        }
        if (targetSession.players.length != 1) {
            _revertDueNotValidGameSessionStatus();
        }
        if (targetSession.players[0] == msg.sender) {
            revert Error("You are already member of game session.");
        }
    }

    function _ensureRevealAllowed(GameTypes.GameSession storage targetSession) private view {
        bool validSessionStatus = targetSession.sessionStatus == GameSessionStatus.TwoCommit || targetSession.sessionStatus == GameSessionStatus.OneReveal;

        if (!validSessionStatus) {
            _revertDueNotValidGameSessionStatus();
        }

        for (uint256 i = 0; i < targetSession.reveals.length; i++) {
            if (targetSession.reveals[i].playerAddress == msg.sender) {
                revert Error("You are already revealed in this game session.");
            }
        }
    }

    function _ensureDistributeAllowed(GameTypes.GameSession storage targetSession) private view {
        if (targetSession.sessionStatus != GameSessionStatus.TwoReveal) {
            _revertDueNotValidGameSessionStatus();
        }
    }
}