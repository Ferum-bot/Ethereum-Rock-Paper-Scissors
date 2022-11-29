import { BigNumber } from "ethers";
import {RPSTokenApi} from "../rps-token.api";

export class EthereumRPSTokenApi implements RPSTokenApi {

    public async getDonationValue(): Promise<BigNumber> {
        return Promise.resolve(BigNumber.from(2));
    }

    public async getTimeLockDurationValue(): Promise<BigNumber> {
        return Promise.resolve(BigNumber.from(2));
    }

    public async takeFreeCoins(): Promise<void> {
        return Promise.resolve(undefined);
    }
}