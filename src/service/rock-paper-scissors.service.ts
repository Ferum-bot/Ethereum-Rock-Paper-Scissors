import {inject, injectable} from "inversify";
import {RockPaperScissorsApi} from "../api/rock-paper-scissors.api";
import {TYPES} from "../di/types";
import {EthereumWeiFormat} from "./models/enums";
import {utils} from "ethers";

@injectable()
export class RockPaperScissorsService {

    @inject(TYPES.RockPaperScissorsApi)
    private api: RockPaperScissorsApi | undefined

    public async getCommissionPercent(): Promise<number> {
        return await this.api?.getCommissionPercent()!
    }

    public async getMinBidValue(format: EthereumWeiFormat): Promise<string> {
        const weiMinBidValue = await this.api?.getMinBidValue()!

        switch (format) {
            case EthereumWeiFormat.ETHER:
                return utils.formatEther(weiMinBidValue);
            case EthereumWeiFormat.WEI:
                return weiMinBidValue;
        }

        return weiMinBidValue
    }
}