import {Container} from "inversify";
import "reflect-metadata";
import {RockPaperScissorsApi} from "../api/rock-paper-scissors.api";
import {TYPES} from "./types";
import {EthereumRockPaperScissorsApi} from "../api/ethereum/ethereum.rock-paper-scissors.api";
import {EthereumRockPaperScissorsEventApi} from "../api/ethereum/ethereum.rock-paper-scissors.event-api";
import {RockPaperScissorsService} from "../service/rock-paper-scissors.service";
import {GameSmartContract} from "../api/ethereum/types";

const container = new Container()

container
    .bind<RockPaperScissorsApi>(TYPES.RockPaperScissorsApi)
    .to(EthereumRockPaperScissorsApi);
container
    .bind<RockPaperScissorsEventApi>(TYPES.RockPaperScissorsEventApi)
    .to(EthereumRockPaperScissorsEventApi);
container
    .bind<RockPaperScissorsService>(RockPaperScissorsService)
    .toSelf()
container
    .bind<GameSmartContract>(GameSmartContract)
    .toSelf()

export { container }
