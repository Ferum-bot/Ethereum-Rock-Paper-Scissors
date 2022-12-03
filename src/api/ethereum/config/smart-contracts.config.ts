import {ethers} from "ethers";
// @ts-ignore
import rockPaperScissorsContractJSON from "../../../../artifacts/contracts/RockPaperScissors.sol/RockPaperScissors.json";
// @ts-ignore
import gameTypesContractJSON from "../../../../artifacts/contracts/util/GameTypes.sol/GameTypes.json";
// @ts-ignore
import randomUtilContractJSON from "../../../../artifacts/contracts/util/RandomUtil.sol/RandomUtil.json";
// @ts-ignore
import rpsTokenContractJSON from "../../../../artifacts/contracts/tokens/RPS-Token.sol/RPS.json";
// @ts-ignore
import gameLogicServiceContractJSON from "../../../../artifacts/contracts/service/GameLogicService.sol/GameLogicService.json";
// @ts-ignore
import gamePaymentsServiceContractJSON from "../../../../artifacts/contracts/service/GamePaymentsService.sol/GamePaymentsService.json";

import {getProvider} from "../../../core/ethereum.helpers";

const {
    PRIVATE_KEY,
    ROCK_PAPER_SCISSORS_CONTRACT_ADDRESS,
    GAME_LOGIC_SERVICE_CONTRACT_ADDRESS,
    GAME_PAYMENTS_SERVICE_CONTRACT_ADDRESS,
    RPS_TOKEN_CONTRACT_ADDRESS,
    GAME_TYPES_CONTRACT_ADDRESS,
    RANDOM_UTIL_CONTRACT_ADDRESS,
} = process.env

const provider = getProvider()

const signer = new ethers.Wallet(PRIVATE_KEY!, provider);

export const rockPaperScissorsContract = new ethers.Contract(
    ROCK_PAPER_SCISSORS_CONTRACT_ADDRESS!,
    rockPaperScissorsContractJSON.abi,
    signer
);
export const gameTypesContract = new ethers.Contract(
    GAME_TYPES_CONTRACT_ADDRESS!,
    gameTypesContractJSON.abi,
    signer
);
export const randomUtilContract = new ethers.Contract(
    RANDOM_UTIL_CONTRACT_ADDRESS!,
    randomUtilContractJSON.abi,
    signer
);
export const rpsTokenContract = new ethers.Contract(
    RPS_TOKEN_CONTRACT_ADDRESS!,
    rpsTokenContractJSON.abi,
    signer
);
export const gameLogicServiceContract = new ethers.Contract(
    GAME_LOGIC_SERVICE_CONTRACT_ADDRESS!,
    gameLogicServiceContractJSON.abi,
    signer
);
export const gamePaymentsServiceContract = new ethers.Contract(
    GAME_PAYMENTS_SERVICE_CONTRACT_ADDRESS!,
    gamePaymentsServiceContractJSON.abi,
    signer
);