require("dotenv").config();
require("@nomiclabs/hardhat-ethers");

const { API_URL, PRIVATE_KEY, NETWORK } = process.env;

module.exports = {
    solidity: "0.8.5",
    defaultNetwork: NETWORK,
    networks: {
        hardhat: {},
        localhost: {
            accounts: [ `${PRIVATE_KEY}` ],
        },
    },
};