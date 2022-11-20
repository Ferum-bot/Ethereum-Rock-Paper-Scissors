import "@nomiclabs/hardhat-ethers";
import {genericDeploy} from "./generic-deploy";
import * as dotenv from 'dotenv';

dotenv.config()

const RPS_TOKEN = "RPS"
const RANDOM_UTIL = "RandomUtil"
const GAME_LOGIC_SERVICE = "GameLogicService"
const GAME_PAYMENT_SERVICE = "GamePaymentsService"
const ROCK_PAPER_SCISSORS = "RockPaperScissors"

const {
    COMMISSION_HANDLER_ADDRESS, DEPOSIT_HANDLER_ADDRESS,
    COMMISSION_PERCENT, MIN_BID_VALUE, DONATION, TIME_LOCK_DURATION
} = process.env

async function contractDeploy() {
    const tokenDeployResult = await genericDeploy({
        contractName: RPS_TOKEN,
        constructorParams: Array.of(TIME_LOCK_DURATION, DONATION),
        additional: Array.of()
    })
    const randomUtilDeployResult = await genericDeploy({
        contractName: RANDOM_UTIL,
        constructorParams: Array.of(),
        additional: Array.of()
    })
    const gameLogicServiceDeployResult = await genericDeploy({
        contractName: GAME_LOGIC_SERVICE,
        constructorParams: Array.of(),
        additional: Array.of()
    });
    const gamePaymentServiceDeployResult = await genericDeploy({
        contractName: GAME_PAYMENT_SERVICE,
        constructorParams: Array.of(),
        additional: Array.of()
    })

    const contractDeployResult = await genericDeploy({
        contractName: ROCK_PAPER_SCISSORS,
        constructorParams: Array.of(
            COMMISSION_HANDLER_ADDRESS, DEPOSIT_HANDLER_ADDRESS,
            COMMISSION_PERCENT, MIN_BID_VALUE
        ),
        additional: Array.of(
            { name: RANDOM_UTIL, address: randomUtilDeployResult.address },
            { name: GAME_LOGIC_SERVICE, address: gameLogicServiceDeployResult.address },
            { name: GAME_PAYMENT_SERVICE, address: gamePaymentServiceDeployResult.address }
        )
    })

    console.info(`Game contract address: ${contractDeployResult.address}`)
}

contractDeploy()
    .then(() => console.info("Deploy finishes"))
    .catch(err => console.error(err));