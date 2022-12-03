import {PlayerChoice} from "../../service/models/enums";

export interface GetGameWinnerParams {
    readonly firstPlayerAddress: string
    readonly firstPlayerChoice: PlayerChoice

    readonly secondPlayerAddress: string
    readonly secondPlayerChoice: PlayerChoice
}

export interface GameWinner {
    readonly winnerAddress: string
    readonly looserAddress: string
}

export const DRAW = '0x0'