import {BigNumber} from "ethers";

export interface RPSTokenApi {

    takeFreeCoins(): Promise<void>

    getDonationValue(): Promise<BigNumber>

    getTimeLockDurationValue(): Promise<BigNumber>
}