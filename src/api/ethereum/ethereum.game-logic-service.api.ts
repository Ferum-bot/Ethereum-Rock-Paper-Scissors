import {GameLogicServiceApi} from "../game-logic-service.api";
import {GameWinner, GetGameWinnerParams} from "../models/game-logic-service.params";
import {inject, injectable} from "inversify";
import {ethers} from "ethers";
import {TYPES} from "../../di/types";

@injectable()
export class EthereumGameLogicServiceApi implements GameLogicServiceApi {

    @inject(TYPES.GameLogicServiceContract)
    private contract: ethers.Contract | undefined

    public async getGameWinner(params: GetGameWinnerParams): Promise<GameWinner> {
        return await this.contract!["getGameWinner"](
            params.firstPlayerAddress, params.firstPlayerChoice,
            params.secondPlayerAddress, params.secondPlayerChoice
        )
    }
}