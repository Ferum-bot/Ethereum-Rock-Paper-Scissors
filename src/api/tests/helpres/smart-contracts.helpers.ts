import {spawnSync} from "child_process";

function launchLocalEthereumNode() {
    const result = spawnSync("npx hardhat node")
    if (result.error) {
        throw result.error
    }
    console.info(result.output.toString())
    console.info(result.stdout.toString())
}

async function deployAllSmartContracts() {

}

async function configureTestContractsClasses() {

}

export async function prepareSmartContractEnvironmentForTests() {
    await launchLocalEthereumNode()
    await deployAllSmartContracts()
    await configureTestContractsClasses()
}

export async function getWalletAddress(walletNumber: number): Promise<string> {
    return Promise.resolve(`${walletNumber}`)
}