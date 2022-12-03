import {injectable} from "inversify";
import { RockPaperScissorsEventApi } from "../rock-paper-scissors.event-api";
import {BaseEventParams} from "../models/rock-paper-scissors.params";

@injectable()
export class EthereumRockPaperScissorsEventApi implements RockPaperScissorsEventApi {

    public async gameDistributedEvents(params: BaseEventParams): Promise<any> {
        throw new Error(`${params}`)
    }

    public async playerCommittedEvents(params: BaseEventParams): Promise<any> {
        throw new Error(`${params}`)
    }

    public async playerRevealedEvents(params: BaseEventParams): Promise<any> {
        throw new Error(`${params}`)
    }

    public async sessionCreatedEvents(params: BaseEventParams): Promise<any> {
        throw new Error(`${params}`)
    }
}