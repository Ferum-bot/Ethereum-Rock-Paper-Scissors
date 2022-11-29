import {GameLogicServiceApi} from "../game-logic-service.api";
import {GameWinner, GetGameWinnerParams} from "../models/game-logic-service.params";
import {injectable} from "inversify";

@injectable()
export class EthereumGameLogicServiceApi implements GameLogicServiceApi {

    public async getGameWinner(params: GetGameWinnerParams): Promise<GameWinner> {
        return Promise.resolve(undefined);
    }
}