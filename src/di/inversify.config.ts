import {Container} from "inversify";
import "reflect-metadata";
import {RockPaperScissorsApi} from "../api/rock-paper-scissors.api";
import {TYPES} from "./types";
import {EthereumRockPaperScissorsApi} from "../api/ethereum/ethereum.rock-paper-scissors.api";
import {EthereumRockPaperScissorsEventApi} from "../api/ethereum/ethereum.rock-paper-scissors.event-api";
import {RockPaperScissorsService} from "../service/rock-paper-scissors.service";
import {RockPaperScissorsEventApi} from "../api/rock-paper-scissors.event-api";
import {ethers} from "ethers";
import {
    gameLogicServiceContract, gamePaymentsServiceContract,
    gameTypesContract,
    randomUtilContract,
    rockPaperScissorsContract, rpsTokenContract
} from "../api/ethereum/config/smart-contracts.config";
import {GameLogicServiceApi} from "../api/game-logic-service.api";
import {EthereumGameLogicServiceApi} from "../api/ethereum/ethereum.game-logic-service.api";
import {RPSTokenApi} from "../api/rps-token.api";
import {EthereumRPSTokenApi} from "../api/ethereum/ethereum.rps-token.api";

const container = new Container()

container
    .bind<ethers.Contract>(TYPES.RockPaperScissorsContract)
    .toConstantValue(rockPaperScissorsContract)
container
    .bind<ethers.Contract>(TYPES.GameTypesContract)
    .toConstantValue(gameTypesContract)
container
    .bind<ethers.Contract>(TYPES.RandomUtilContract)
    .toConstantValue(randomUtilContract)
container
    .bind<ethers.Contract>(TYPES.RPSTokenContract)
    .toConstantValue(rpsTokenContract)
container
    .bind<ethers.Contract>(TYPES.GameLogicServiceContract)
    .toConstantValue(gameLogicServiceContract)
container
    .bind<ethers.Contract>(TYPES.GamePaymentsServiceContract)
    .toConstantValue(gamePaymentsServiceContract)

container
    .bind<RockPaperScissorsApi>(TYPES.RockPaperScissorsApi)
    .to(EthereumRockPaperScissorsApi);
container
    .bind<RockPaperScissorsEventApi>(TYPES.RockPaperScissorsEventApi)
    .to(EthereumRockPaperScissorsEventApi);
container
    .bind<GameLogicServiceApi>(TYPES.GameLogicServiceApi)
    .to(EthereumGameLogicServiceApi);
container
    .bind<RPSTokenApi>(TYPES.RPSTokenApi)
    .to(EthereumRPSTokenApi);

container
    .bind<RockPaperScissorsService>(RockPaperScissorsService)
    .toSelf()

export { container }
