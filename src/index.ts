import {container} from "./di/inversify.config";
import {RockPaperScissorsService} from "./service/rock-paper-scissors.service";
import {TYPES} from "./di/types";
import * as dotenv from 'dotenv';

dotenv.config()

async function main() {
    const service = container.get<RockPaperScissorsService>(TYPES.RockPaperScissorsService);

    console.info(await service.getCommissionPercent())
}

main().catch(err => console.error(err))
