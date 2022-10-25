import {
    CommitParams,
    CreateNewSessionParams,
    DistributeParams,
    GetGameSessionInfoParams,
    RevealParams
} from "./models/params";

export interface RockPaperScissorsApi {

    getGameSessionInfo(params: GetGameSessionInfoParams): Promise<any>

    createNewSession(params: CreateNewSessionParams): Promise<any>

    commit(params: CommitParams): Promise<any>

    reveal(params: RevealParams): Promise<any>

    distribute(params: DistributeParams): Promise<any>

    getCommissionPercent(): Promise<any>

    getMinBidValue(): Promise<any>
}