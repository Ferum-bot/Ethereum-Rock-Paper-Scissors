import {Container} from "inversify";
import {RockPaperScissorsApi} from "../api/rock-paper-scissors.api";
import {TYPES} from "./types";
import {EthereumRockPaperScissorsApi} from "../api/impl/ethereum.rock-paper-scissors.api";
import {EthereumRockPaperScissorsEventApi} from "../api/impl/ethereum.rock-paper-scissors.event-api";
import {RockPaperScissorsService} from "../service/rock-paper-scissors.service";

const container = new Container()

container
    .bind<RockPaperScissorsApi>(TYPES.RockPaperScissorsApi)
    .to(EthereumRockPaperScissorsApi);
container
    .bind<RockPaperScissorsEventApi>(TYPES.RockPaperScissorsEventApi)
    .to(EthereumRockPaperScissorsEventApi);
container
    .bind<RockPaperScissorsService>(TYPES.RockPaperScissorsService)
    .toSelf()

export { container }
