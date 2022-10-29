import {ethers} from "ethers";
import {gameContract} from "./config/smart-contract.config";
import {injectable} from "inversify";

@injectable()
export class GameSmartContract {

    readonly instance: ethers.Contract = gameContract;
}