import {Provider} from "@ethersproject/abstract-provider";
import {ethers} from "ethers";

export function getProvider(): Provider {
    const { MODE } = process.env

    function localHostProvider() {
        return ethers.providers.getDefaultProvider("http://127.0.0.1:8545");
    }

    function alchemyProvider() {
        const { NETWORK, API_KEY} = process.env;
        return new ethers.providers.AlchemyProvider(NETWORK, API_KEY)
    }

    let provider: Provider = alchemyProvider()
    if (MODE == 'dev') {
        provider = localHostProvider()
    }

    return provider
}