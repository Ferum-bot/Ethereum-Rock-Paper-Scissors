export interface DeployResult {
    readonly address: string
}

export interface AdditionalContracts {
    readonly name: string
    readonly address: string
}

export interface DeployParams {
    readonly contractName: string
    readonly constructorParams: Array<any>
    readonly additional: Array<AdditionalContracts>
}