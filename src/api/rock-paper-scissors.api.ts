import {
    CommitParams,
    CreateNewSessionParams,
    DistributeParams,
    RevealParams
} from "./models/params";
import {BigNumber} from "ethers";

export interface RockPaperScissorsApi {

    createNewSession(params: CreateNewSessionParams): Promise<any>

    commit(params: CommitParams): Promise<any>

    reveal(params: RevealParams): Promise<any>

    distribute(params: DistributeParams): Promise<any>

    getCommissionPercent(): Promise<BigNumber>

    getMinBidValue(): Promise<BigNumber>
}