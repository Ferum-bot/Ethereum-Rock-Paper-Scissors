import {BigNumber} from "ethers";
import {PlayerChoice} from "../../service/models/enums";

export type CreateNewSessionParams = {
    bidValue: BigNumber
    randomValue: BigNumber
}

export type CommitParams = {
    inviteLink: string
}

export type RevealParams = {
    sessionId: BigNumber
    choice: PlayerChoice
}

export type DistributeParams = {
    sessionId: BigNumber
}

export type BaseEventParams = {
    blockNumberFrom: number
    blockNumberTo: number
}