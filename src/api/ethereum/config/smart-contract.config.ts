import {ethers} from "ethers";
// @ts-ignore
import contract from "../../../../artifacts/contracts/RockPaperScissors.sol/RockPaperScissors.json";

const { NETWORK, API_KEY, PRIVATE_KEY, CONTRACT_ADDRESS } = process.env;
const provider = new ethers.providers.AlchemyProvider(NETWORK, API_KEY)
const signer = new ethers.Wallet(PRIVATE_KEY!, provider);
export const gameContract = new ethers.Contract(CONTRACT_ADDRESS!, contract.abi, signer);