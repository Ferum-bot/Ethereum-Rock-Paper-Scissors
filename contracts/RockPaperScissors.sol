// SPDX-License-Identifier: 0BSD
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

    address private commissionHandler;
    address private depositHandler;
    address private admin;

    uint256 private commissionPercent;
    uint256 private minBidValue;

    GameTypes.GameSession[] private sessions;
    mapping(uint256 => GameTypes.GameSession) private gameIdToGameSession;
    mapping(string => GameTypes.GameSession) private gameInviteLinkToSession;
    mapping(uint256 => bool) private gameIdToExists;
    mapping(string => bool) private gameInviteLinkToExists;

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
        uint256 bidValue,
        uint256 randomValue
    ) external createSessionAllowed(bidValue) returns (string memory) {
        GameTypes.GameSession memory gameSession;

        uint256 blockHash = uint256(blockhash(block.number - 1));
        string memory inviteLink = RandomUtil.getRandomString(blockHash);
        uint256 sessionId = RandomUtil.getUniqueIdentifier(randomValue);

        if (gameInviteLinkToExists[inviteLink]) {
            revert("Failed to create invitation link. Please try again.");
        }
        if (gameIdToExists[sessionId]) {
            revert("Failed to create game session. Please try with another random value.");
        }

        gameSession.id = sessionId;
        gameSession.inviteLink = inviteLink;
        gameSession.bidValue = bidValue;
        gameSession.firstPlayer = msg.sender;
        gameSession.firstPlayerReveal = GameTypes.PlayerChoice.None;
        gameSession.secondPlayerReveal = GameTypes.PlayerChoice.None;
        gameSession.sessionStatus = GameTypes.GameSessionStatus.OneCommit;

        GamePaymentsService.reserveDeposit(
            payable(msg.sender),
            payable(depositHandler),
            bidValue
        );

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
    ) external commitAllowed(inviteLink) returns (uint256) {
        GameTypes.GameSession storage targetSession = gameInviteLinkToSession[inviteLink];

        GamePaymentsService.reserveDeposit(
            msg.sender,
            depositHandler,
            targetSession.bidValue
        );

        targetSession.secondPlayer = msg.sender;
        targetSession.sessionStatus = GameTypes.GameSessionStatus.TwoCommit;

        emit PlayerCommitted(targetSession.id, msg.sender);

        return targetSession.id;
    }

    function reveal(
        uint256 sessionId,
        GameTypes.PlayerChoice choice
    ) external revealAllowed(sessionId, choice) {
        GameTypes.GameSession storage targetSession = gameIdToGameSession[sessionId];

        if (targetSession.sessionStatus == GameTypes.GameSessionStatus.TwoCommit) {
            targetSession.sessionStatus = GameTypes.GameSessionStatus.OneReveal;
        }
        if (targetSession.sessionStatus == GameTypes.GameSessionStatus.OneReveal) {
            targetSession.sessionStatus = GameTypes.GameSessionStatus.TwoReveal;
        }
        if (targetSession.firstPlayer == msg.sender) {
            targetSession.firstPlayerReveal = choice;
        } else {
            targetSession.secondPlayerReveal = choice;
        }

        emit PlayerRevealed(targetSession.id, msg.sender);
    }

    function distribute(
        uint256 sessionId
    ) external distributeAllowed(sessionId) returns (address, address) {
        GameTypes.GameSession storage targetSession = gameIdToGameSession[sessionId];

        address firstPlayer = targetSession.firstPlayer;
        address secondPlayer = targetSession.secondPlayer;

        (address winner, address looser) = GameLogicService.getGameWinner(
            firstPlayer, targetSession.firstPlayerReveal,
            secondPlayer, targetSession.secondPlayerReveal
        );

        if (winner == looser) {
            GamePaymentsService.returnDeposit(
                firstPlayer,
                depositHandler,
                targetSession.bidValue
            );
            GamePaymentsService.returnDeposit(
                secondPlayer,
                depositHandler,
                targetSession.bidValue
            );
        } else {
            GamePaymentsService.payAndTakeCommission(
                winner, targetSession.bidValue,
                depositHandler, commissionHandler,
                commissionPercent
            );
        }

        targetSession.sessionStatus = GameTypes.GameSessionStatus.Distributed;
        emit GameDistributed(targetSession.id, winner);

        return (winner, looser);
    }

    function getCommissionPercent() external view returns (uint256) {
        return commissionPercent;
    }

    function getMinBidValue() external view returns (uint256) {
        return minBidValue;
    }

    modifier gameIsDistributed(uint256 sessionId) {
        _ensureGameSessionExists(sessionId);
        GameTypes.GameSession storage session = gameIdToGameSession[sessionId];
        if (session.sessionStatus != GameTypes.GameSessionStatus.Distributed) {
            _revertDueNotValidGameSessionStatus();
        }
        _;
    }

    modifier createSessionAllowed(uint256 bidValue) {
        require(bidValue >= minBidValue, "Bid value is too small.");
        _;
    }

    modifier commitAllowed(string memory inviteLink) {
        _ensureGameSessionExists(inviteLink);
        _ensureGameSessionIsActive(inviteLink);
        GameTypes.GameSession storage targetSession = gameInviteLinkToSession[inviteLink];
        _ensureCommitAllowed(targetSession);
        _;
    }

    modifier revealAllowed(uint256 sessionId, GameTypes.PlayerChoice choice) {
        _ensurePlayerChoiceValid(choice);
        _ensureGameSessionExists(sessionId);
        _ensureGameSessionIsActive(sessionId);
        _ensureSenderIsMemberOfGame(sessionId);
        GameTypes.GameSession storage targetSession = gameIdToGameSession[sessionId];
        _ensureRevealAllowed(targetSession);
        _;
    }

    modifier distributeAllowed(uint256 sessionId) {
        _ensureGameSessionExists(sessionId);
        _ensureGameSessionIsActive(sessionId);
        _ensureSenderIsMemberOfGame(sessionId);
        GameTypes.GameSession storage targetSession = gameIdToGameSession[sessionId];
        _ensureDistributeAllowed(targetSession);
        _;
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
        if (gameSession.firstPlayer == msg.sender) {
            return;
        }
        if (gameSession.secondPlayer == msg.sender) {
            return;
        }
        revert("Sender is not member of game");
    }

    function _ensureGameSessionIsActive(uint256 sessionId) private view {
        _ensureGameSessionExists(sessionId);
        GameTypes.GameSession storage gameSession = gameIdToGameSession[sessionId];
        if (gameSession.sessionStatus == GameTypes.GameSessionStatus.Distributed) {
            revert("Target game session is not active");
        }
    }

    function _ensureGameSessionIsActive(string memory inviteLink) private view {
        _ensureGameSessionExists(inviteLink);
        GameTypes.GameSession storage gameSession = gameInviteLinkToSession[inviteLink];
        if (gameSession.sessionStatus == GameTypes.GameSessionStatus.Distributed) {
            revert("Target game session is not active");
        }
    }

    function _revertDueNotValidGameSessionStatus() private pure {
        revert("Action not applied to game session status.");
    }

    function _ensureCommitAllowed(GameTypes.GameSession storage targetSession) private view {
        if (targetSession.sessionStatus != GameTypes.GameSessionStatus.OneCommit) {
            _revertDueNotValidGameSessionStatus();
        }
        if (targetSession.firstPlayer == msg.sender) {
            revert("You are already member of game session.");
        }
    }

    function _ensurePlayerChoiceValid(GameTypes.PlayerChoice choice) private pure {
        if (choice == GameTypes.PlayerChoice.Rock) {
            return;
        }
        if (choice == GameTypes.PlayerChoice.Paper) {
            return;
        }
        if (choice == GameTypes.PlayerChoice.Scissors) {
            return;
        }
        revert("Invalid player choice");
    }

    function _ensureRevealAllowed(GameTypes.GameSession storage targetSession) private view {
        bool validSessionStatus = targetSession.sessionStatus == GameTypes.GameSessionStatus.TwoCommit || targetSession.sessionStatus == GameTypes.GameSessionStatus.OneReveal;

        if (!validSessionStatus) {
            _revertDueNotValidGameSessionStatus();
        }

        if (targetSession.firstPlayer == msg.sender && targetSession.firstPlayerReveal != GameTypes.PlayerChoice.None) {
            revert("You are already revealed in this game session.");
        }
        if (targetSession.secondPlayer == msg.sender && targetSession.secondPlayerReveal != GameTypes.PlayerChoice.None) {
            revert("You are already revealed in this game session.");
        }
    }

    function _ensureDistributeAllowed(GameTypes.GameSession storage targetSession) private view {
        if (targetSession.sessionStatus != GameTypes.GameSessionStatus.TwoReveal) {
            _revertDueNotValidGameSessionStatus();
        }
    }
}