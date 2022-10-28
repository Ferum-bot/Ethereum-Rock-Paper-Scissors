import {container} from "./di/inversify.config";
import {RockPaperScissorsService} from "./service/rock-paper-scissors.service";
import {TYPES} from "./di/types";

async function main() {
    const service = container.get<RockPaperScissorsService>(TYPES.RockPaperScissorsService);
    service.toString()
}

main().catch(err => console.error(err))
