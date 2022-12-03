import {spawnSync} from "child_process";

let ethereumNodeProcessPid = -1

function launchLocalEthereumNode() {
    const result = spawnSync("npx hardhat node")
    if (result.error) {
        throw result.error
    }
    ethereumNodeProcessPid = result.pid
    console.info(result.output.toString())
    console.info(result.stdout.toString())
}

async function deployAllSmartContracts() {

}

async function configureTestContractsClasses() {

}

export function dropLocalEthereumNode() {
    if (ethereumNodeProcessPid !== -1) {
        process.kill(ethereumNodeProcessPid, 'SIGINT')
    }
}

export async function prepareSmartContractEnvironmentForTests() {
    await launchLocalEthereumNode()
    await deployAllSmartContracts()
    await configureTestContractsClasses()
}

export async function getWalletAddress(walletNumber: number): Promise<string> {
    return Promise.resolve(`${walletNumber}`)
}