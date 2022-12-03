import {RockPaperScissorsApi} from "../rock-paper-scissors.api";
import {
    CommitParams,
    CreateNewSessionParams,
    DistributeParams,
    RevealParams
} from "../models/rock-paper-scissors.params";
import {inject, injectable} from "inversify";
import {BigNumber, ethers} from "ethers";
import {TYPES} from "../../di/types";

@injectable()
export class EthereumRockPaperScissorsApi implements RockPaperScissorsApi {

    @inject(TYPES.RockPaperScissorsContract)
    private contract: ethers.Contract | undefined

    public async commit(params: CommitParams): Promise<any> {
        return await this.contract!["commit"](params.inviteLink);
    }

    public async createNewSession(params: CreateNewSessionParams): Promise<any> {
        return await this.contract!["createNewSession"](params.bidValue, params.randomValue);
    }

    public async distribute(params: DistributeParams): Promise<any> {
        return await this.contract!["distribute"](params.sessionId);
    }

    public async getCommissionPercent(): Promise<BigNumber> {
        return await this.contract!["getCommissionPercent"]()
    }

    public async getMinBidValue(): Promise<BigNumber> {
        return await this.contract!["getMinBidValue"]();
    }

    public async reveal(params: RevealParams): Promise<any> {
        return await this.contract!["reveal"](params.sessionId, params.choice);
    }
}