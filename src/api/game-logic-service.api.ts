import {GameWinner, GetGameWinnerParams} from "./models/game-logic-service.params";

export interface GameLogicServiceApi {

    getGameWinner(params: GetGameWinnerParams): Promise<GameWinner>
}