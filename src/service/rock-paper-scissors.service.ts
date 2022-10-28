import {inject, injectable} from "inversify";
import {RockPaperScissorsApi} from "../api/rock-paper-scissors.api";
import {TYPES} from "../di/types";
import {EthereumWeiFormat} from "./models/enums";

@injectable()
export class RockPaperScissorsService {

    @inject(TYPES.RockPaperScissorsApi)
    private api: RockPaperScissorsApi

    @inject(TYPES.RockPaperScissorsEventApi)
    private eventApi: RockPaperScissorsEventApi

    public getCommissionPercent(): number {
        return 23
    }

    public getMinBidValue(format: EthereumWeiFormat): number {
        return format
    }
}