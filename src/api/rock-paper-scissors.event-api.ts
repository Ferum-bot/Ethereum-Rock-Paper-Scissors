import {BaseEventParams} from "./models/params";

export interface RockPaperScissorsEventApi {

    sessionCreatedEvents(params: BaseEventParams): Promise<any>

    playerCommittedEvents(params: BaseEventParams): Promise<any>

    playerRevealedEvents(params: BaseEventParams): Promise<any>

    gameDistributedEvents(params: BaseEventParams): Promise<any>
}