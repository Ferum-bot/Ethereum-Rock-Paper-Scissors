import {RockPaperScissorsApi} from "../rock-paper-scissors.api";
import {
    CommitParams,
    CreateNewSessionParams,
    DistributeParams,
    GetGameSessionInfoParams,
    RevealParams
} from "../models/params";

export class EthereumRockPaperScissorsApi implements RockPaperScissorsApi {

    commit(params: CommitParams): Promise<any> {
        return Promise.resolve(undefined);
    }

    createNewSession(params: CreateNewSessionParams): Promise<any> {
        return Promise.resolve(undefined);
    }

    distribute(params: DistributeParams): Promise<any> {
        return Promise.resolve(undefined);
    }

    getCommissionPercent(): Promise<any> {
        return Promise.resolve(undefined);
    }

    getGameSessionInfo(params: GetGameSessionInfoParams): Promise<any> {
        return Promise.resolve(undefined);
    }

    getMinBidValue(): Promise<any> {
        return Promise.resolve(undefined);
    }

    reveal(params: RevealParams): Promise<any> {
        return Promise.resolve(undefined);
    }
}