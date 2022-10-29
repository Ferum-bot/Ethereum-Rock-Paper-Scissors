import {ethers} from "hardhat";
import {DeployParams, DeployResult} from "./types";

export async function genericDeploy(params: DeployParams): Promise<DeployResult> {
    const contract = await ethers.getContractFactory(params.contractName, {
        libraries: params.additional.reduce((acc, {name, address}) => ({
          ...acc, [name]: address
        }), {})
    });
    const gasPrice = await contract.signer.getGasPrice();

    console.info(`[${params.contractName}] Current gas price: ${gasPrice}`)

    const estimatedGas = await contract.signer.estimateGas(
        contract.getDeployTransaction(...params.constructorParams)
    );

    console.info(`[${params.contractName}] Estimated gas: ${estimatedGas}`)

    const deployPrice = await gasPrice.mul(estimatedGas);
    const deployerBalance = await contract.signer.getBalance();

    console.info(`[${params.contractName}] Deploy price: ${deployPrice}`)
    console.info(`[${params.contractName}] Deployer balance: ${deployerBalance}`)

    if (Number(deployPrice) > Number(deployerBalance)) {
        throw new Error(`[${params.contractName}] You do not have enough balance to contractDeploy`)
    }

    const deploy = await contract.deploy(...params.constructorParams)
    await deploy.deployed()

    console.info(`[${params.contractName}] Contract deployed to address: ${deploy.address}`)

    return {
        address: deploy.address
    }
}