import {GameSessionStatus, PlayerChoice} from "./enums";
import {BigNumber} from "ethers";

export interface PlayerReveal {
    readonly address: string
    readonly choice: PlayerChoice
}

export interface GameSession {
    readonly id: BigNumber
    readonly inviteLink: string
    readonly playerAddresses: Array<string>
    readonly bidValue: BigNumber

    readonly sessionStatus: GameSessionStatus

    readonly reveals: Array<PlayerReveal>
}