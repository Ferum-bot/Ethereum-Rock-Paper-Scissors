import {ethers} from "ethers";
// @ts-ignore
import contract from "../../../../artifacts/contracts/RockPaperScissors.sol/RockPaperScissors.json";
import {Provider} from "@ethersproject/abstract-provider";

function localHostProvider() {
    return ethers.providers.getDefaultProvider("http://127.0.0.1:8545");
}

function alchemyProvider() {
    const { NETWORK, API_KEY} = process.env;
    return new ethers.providers.AlchemyProvider(NETWORK, API_KEY)
}
const { PRIVATE_KEY, CONTRACT_ADDRESS, MODE } = process.env
let provider: Provider = alchemyProvider()
if (MODE == 'dev') {
    provider = localHostProvider()
}

const signer = new ethers.Wallet(PRIVATE_KEY!, provider);
export const gameContract = new ethers.Contract(CONTRACT_ADDRESS!, contract.abi, signer);