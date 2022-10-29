import "@nomiclabs/hardhat-ethers";
import {ethers} from "hardhat";

async function deploy() {
    const contract = await ethers.getContractFactory("RockPaperScissors");
    const gasPrice = await contract.signer.getGasPrice();

    console.info(`Current gas price: ${gasPrice}`)

    const estimatedGas = await contract.signer.estimateGas(
        contract.getDeployTransaction()
    );

    console.info(`Estimated gas: ${estimatedGas}`)

    const deployPrice = await gasPrice.mul(estimatedGas);
    const deployerBalance = await contract.signer.getBalance();

    console.info(`Deploy price: ${deployPrice}`)
    console.info(`Deployer balance: ${deployerBalance}`)

    if (Number(deployPrice) > Number(deployerBalance)) {
        throw new Error("You do not have enough balance to deploy")
    }

    const deploy = await contract.deploy()
    await deploy.deployed()

    console.info(`Contract deployed to ${deploy.address}`)
}

deploy()
    .then(() => console.info("Deploy finishes"))
    .catch(err => console.error(err));