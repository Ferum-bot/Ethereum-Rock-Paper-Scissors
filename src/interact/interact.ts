import {container} from "../di/inversify.config";
import {RockPaperScissorsService} from "../service/rock-paper-scissors.service";
import * as dotenv from 'dotenv';
import {EthereumWeiFormat} from "../service/models/enums";

dotenv.config()

async function main() {
    const service = container.get<RockPaperScissorsService>(RockPaperScissorsService);

    console.info(await service.getMinBidValue(EthereumWeiFormat.ETHER))
}

main().catch(err => console.error(err))
