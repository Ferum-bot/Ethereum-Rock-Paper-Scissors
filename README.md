# Ethereum-Rock-Paper-Scissors

Rock-paper-scissors game based on blockchain technology.
Ethereum based blockchains users can create/join rooms, place bets, invite players and withdraw winnings.

Smart Contract uses Commit-Reveal model. 
The choice(rock, paper or scissors) is absolutely confidential. 
Only after both players have made their choice cards will be on the table.

## Game flow:
1. User creates new game session or join existing by invite link
2. User commits its participation in the game
3. Smart Contract takes deposit from all participants
4. Users reveal their choice(rock, paper or scissors)
5. Users distribute game session. Smart Contract takes commission and pays winning

## Compile contract:
* Run `npm install`
* Run `npm run init-env`
* Run `npx hardhat compile`

## Configuring:

Before interacting with Smart Contract due node client, do following:
* Create `.env` file: `npm run init-env`
* Insert all configure values

```dotenv
API_URL="URL to alchemy application"
API_KEY="API key of alchemy application"
PRIVATE_KEY="Private key of transaction invoker"
NETWORK="Network name, example: goerli"
CONTRACT_ADDRESS="Blockchain address of smart contract"
COMMISSION_HANDLER_ADDRESS="Blockchain address of commission handler"
DEPOSIT_HANDLER_ADDRESS="Blockchain address of deposit handler"
COMMISSION_PERCENT="Percent of commission from bid value, pass in absolute values, example: 20"
MIN_BID_VALUE="Minumal bid value, pass in wei"
MODE="Interaction mode. If passed dev, local ethereum blockchain node will be used"
```

## Deploy:

### Local node:
* Run `npm run setup-ethereum-node`
* Set `MODE=dev`
* Set [hardhat.config.js](./hardhat.config.js) to `localhost` network
* Run `npm run local-deploy`

### External node:
* Fill `.env` file. 
* Set `MODE=external`
* Set [hardhat.config.js](./hardhat.config.js) to your network
* Run `npm run deploy`

## Interaction:
1. Compile Smart Contract
2. Insert all configuration values in `.env` file
3. Run `npm run local-interact` if you want to use local node
4. Run `npm run interact` if you want to use node from configuration file

#### Created and Powered by Ferum-bot
