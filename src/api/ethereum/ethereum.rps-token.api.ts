import {BigNumber, ethers} from "ethers";
import {RPSTokenApi} from "../rps-token.api";
import {inject, injectable} from "inversify";
import {TYPES} from "../../di/types";

@injectable()
export class EthereumRPSTokenApi implements RPSTokenApi {

    @inject(TYPES.RPSTokenContract)
    private contract: ethers.Contract | undefined

    public async getDonationValue(): Promise<BigNumber> {
        if (this.contract) {
            return Promise.resolve(BigNumber.from(23))
        }
        return Promise.resolve(BigNumber.from(2));
    }

    public async getTimeLockDurationValue(): Promise<BigNumber> {
        return Promise.resolve(BigNumber.from(2));
    }

    public async takeFreeCoins(): Promise<void> {
        return Promise.resolve(undefined);
    }
}