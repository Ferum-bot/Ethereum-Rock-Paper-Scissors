import {container as diContainer} from "../../di/inversify.config";
import {TYPES} from "../../di/types";
import {GameLogicServiceApi} from "../game-logic-service.api";
import {afterAll, beforeAll, beforeEach, describe, expect, test} from '@jest/globals';
import {EthereumGameLogicServiceApi} from "../ethereum/ethereum.game-logic-service.api";
import {
    dropLocalEthereumNode,
    getWalletAddress,
    prepareSmartContractEnvironmentForTests
} from "./helpres/smart-contracts.helpers";
import {DRAW, GameWinner, GetGameWinnerParams} from "../models/game-logic-service.params";
import {PlayerChoice} from "../../service/models/enums";

describe('ethereum-game-logic-service', () => {

    beforeAll(async () => {
        await prepareSmartContractEnvironmentForTests()
    })

    afterAll(async () => {
        await dropLocalEthereumNode()
    })

    beforeEach(async () => {
        firstPlayerAddress = await getWalletAddress(0);
        secondPlayerAddress = await getWalletAddress(1);
    })

    let firstPlayerAddress: string
    let secondPlayerAddress: string

    test('should be defined as ethereum class', () => {
        const api = diContainer.get<GameLogicServiceApi>(TYPES.GameLogicServiceApi)

        expect(api).toBeInstanceOf(EthereumGameLogicServiceApi)
    })

    test('get game winner where first choice is Rock and second is Paper', async () => {
        const api = diContainer.get<GameLogicServiceApi>(TYPES.GameLogicServiceApi)
        const params: GetGameWinnerParams = {
            firstPlayerChoice: PlayerChoice.ROCK,
            secondPlayerChoice: PlayerChoice.PAPER,
            firstPlayerAddress, secondPlayerAddress
        }

        const gameWinner = await api.getGameWinner(params)

        expect<GameWinner>(gameWinner).toBe({
            winnerAddress: secondPlayerAddress,
            looserAddress: firstPlayerAddress
        } as GameWinner)
    })

    test('get game winner where first choice is Paper and second is Scissors', async () => {
        const api = diContainer.get<GameLogicServiceApi>(TYPES.GameLogicServiceApi)
        const params: GetGameWinnerParams = {
            firstPlayerChoice: PlayerChoice.PAPER,
            secondPlayerChoice: PlayerChoice.SCISSORS,
            firstPlayerAddress, secondPlayerAddress
        }

        const gameWinner = await api.getGameWinner(params)

        expect<GameWinner>(gameWinner).toBe({
            winnerAddress: secondPlayerAddress,
            looserAddress: firstPlayerAddress
        } as GameWinner)
    })

    test('get game winner where first choice is Scissors and second is Rock', async () => {
        const api = diContainer.get<GameLogicServiceApi>(TYPES.GameLogicServiceApi)
        const params: GetGameWinnerParams = {
            firstPlayerChoice: PlayerChoice.SCISSORS,
            secondPlayerChoice: PlayerChoice.ROCK,
            firstPlayerAddress, secondPlayerAddress
        }

        const gameWinner = await api.getGameWinner(params)

        expect<GameWinner>(gameWinner).toBe({
            winnerAddress: secondPlayerAddress,
            looserAddress: firstPlayerAddress
        } as GameWinner)
    })

    test('get game winner where first choice is Paper and second is Rock', async () => {
        const api = diContainer.get<GameLogicServiceApi>(TYPES.GameLogicServiceApi)
        const params: GetGameWinnerParams = {
            firstPlayerChoice: PlayerChoice.PAPER,
            secondPlayerChoice: PlayerChoice.ROCK,
            firstPlayerAddress, secondPlayerAddress
        }

        const gameWinner = await api.getGameWinner(params)

        expect<GameWinner>(gameWinner).toBe({
            winnerAddress: firstPlayerAddress,
            looserAddress: secondPlayerAddress
        } as GameWinner)
    })

    test('get game winner where first choice is Paper and second is Paper', async () => {
        const api = diContainer.get<GameLogicServiceApi>(TYPES.GameLogicServiceApi)
        const params: GetGameWinnerParams = {
            firstPlayerChoice: PlayerChoice.PAPER,
            secondPlayerChoice: PlayerChoice.PAPER,
            firstPlayerAddress, secondPlayerAddress
        }

        const gameWinner = await api.getGameWinner(params)

        expect<GameWinner>(gameWinner).toBe({
            winnerAddress: DRAW,
            looserAddress: DRAW
        } as GameWinner)
    })

    test('get game winner where first choice is None and second is Paper', async () => {
        const api = diContainer.get<GameLogicServiceApi>(TYPES.GameLogicServiceApi)
        const params: GetGameWinnerParams = {
            firstPlayerChoice: PlayerChoice.NONE,
            secondPlayerChoice: PlayerChoice.PAPER,
            firstPlayerAddress, secondPlayerAddress
        }

        const gameWinner = api.getGameWinner(params)

        await expect(gameWinner).resolves.toBeUndefined()
        await expect(gameWinner).rejects.toBeDefined()
    })

    test('get game winner where first choice is Rock and second is None', async () => {
        const api = diContainer.get<GameLogicServiceApi>(TYPES.GameLogicServiceApi)
        const params: GetGameWinnerParams = {
            firstPlayerChoice: PlayerChoice.ROCK,
            secondPlayerChoice: PlayerChoice.NONE,
            firstPlayerAddress, secondPlayerAddress
        }

        const gameWinner = api.getGameWinner(params)

        await expect(gameWinner).resolves.toBeUndefined()
        await expect(gameWinner).rejects.toBeDefined()
    })

    test('get game winner where first choice is None and second is None', async () => {
        const api = diContainer.get<GameLogicServiceApi>(TYPES.GameLogicServiceApi)
        const params: GetGameWinnerParams = {
            firstPlayerChoice: PlayerChoice.NONE,
            secondPlayerChoice: PlayerChoice.NONE,
            firstPlayerAddress, secondPlayerAddress
        }

        const gameWinner = api.getGameWinner(params)

        await expect(gameWinner).resolves.toBeUndefined()
        await expect(gameWinner).rejects.toBeDefined()
    })
})