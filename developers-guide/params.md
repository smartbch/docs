# All Params



| Package      | Param                                  | CLI option         | ChainConfig Field       | Constant\|Variable                                  |
| ------------ | -------------------------------------- | ------------------ | ----------------------- | --------------------------------------------------- |
| smartbch/app | PruneEveryN                            |                    |                         | app.go/PruneEveryN/10                               |
|              | ChangeRetainEveryN                     |                    |                         | app.go/ChangeRetainEveryN/100                       |
|              | DefaultTrunkCacheSize                  |                    |                         | app.go/DefaultTrunkCacheSize200                     |
|              | RpcEthGetLogsMaxResults                |                    | RpcEthGetLogsMaxResults | config.go/DefaultRpcEthGetLogsMaxResults /10000     |
|              | app.retainBlocks                       | retain             | RetainBlocks            | config.go/DefaultRetainBlocks/-1                    |
|              | app.numKeptBlocks                      |                    | NumKeptBlocks           | config.go/DefaultNumKeptBlocks/10000                |
|              | app.numKeptBlocksInMoDB                |                    | NumKeptBlocksInMoDB     | config.go/DefaultNumKeptBlocksInMoDB/-1             |
|              | app.sigCacheSize                       |                    | SigCacheSize            | config.go/DefaultSignatureCache/20000               |
|              | app.recheckThreshold                   |                    | RecheckThreshold        | config.go/DefaultRecheckThreshold/1000              |
|              | UseLiteDB                              |                    | UseLiteDB               |                                                     |
|              | MainnetRPCUrl                          | mainnet-url        | MainnetRPCUrl           |                                                     |
|              | MainnetRPCUserName                     | mainnet-user       | MainnetRPCUserName      |                                                     |
|              | MainnetRPCUserName                     | mainnet-password   | MainnetRPCPassword      |                                                     |
|              | SmartBchRPCUrl                         | smartbch-url       | SmartBchRPCUrl          |                                                     |
|              | Speedup                                | watcher-speedup    | Speedup                 |                                                     |
|              | LogValidatorsInfo                      | log-validators     | LogValidatorsInfo       |                                                     |
|              | BlockMaxBytes                          |                    |                         | params.go/BlockMaxBytes/24\*1024\*1024              |
|              | BlockMaxGas                            |                    |                         | params.go/BlockMaxGas/900_000_000_000               |
|              | EbpExeRoundCount                       |                    |                         | params.go/EbpExeRoundCount/200                      |
|              | EbpRunnerNumber                        |                    |                         | params.go/EbpRunnerNumber/256                       |
|              | EbpParallelNum                         |                    |                         | params.go/EbpParallelNum/32                         |
|              | MaxTxGasLimit                          |                    |                         | params.go/MaxTxGasLimit/1000_0000                   |
| staking      | StakingEpochCountBeforeRewardMature    |                    |                         | params.go/StakingEpochCountBeforeRewardMature/1     |
|              | StakingBaseProposerPercentage          |                    |                         | params.go/StakingBaseProposerPercentage/15          |
|              | StakingExtraProposerPercentage         |                    |                         | params.go/StakingExtraProposerPercentage/15         |
|              | StakingMinVotingPercentPerEpoch        |                    |                         | params.go/StakingMinVotingPercentPerEpoch/10        |
|              | StakingMinVotingPubKeysPercentPerEpoch |                    |                         | params.go/StakingMinVotingPubKeysPercentPerEpoch/34 |
|              | StakingNumBlocksInEpoch                |                    |                         | params.go/StakingNumBlocksInEpoch/30                |
|              | StakingEpochSwitchDelay                |                    |                         | params.go/StakingEpochSwitchDelay/3\*10+10          |
|              | MaxActiveValidatorNum                  |                    |                         | staking/types/types.go/MaxActiveValidatorNum/30     |
|              | SumVotingPowerGasPerByte               |                    |                         | staking/staking.go/SumVotingPowerGasPerByte/25      |
|              | SumVotingPowerBaseGas                  |                    |                         | staking/staking.go/SumVotingPowerBaseGas/10000      |
|              | InitialStakingAmount                   |                    |                         | staking/staking.go/InitialStakingAmount/1000e18     |
|              | MinimumStakingAmount                   |                    |                         | staking/staking.go/MinimumStakingAmount/800e8       |
|              | SlashedStakingAmount                   |                    |                         | staking/staking.go/SlashedStakingAmount/10e8        |
|              | GasOfValidatorOp                       |                    |                         | staking/staking.go/GasOfValidatorOp/400_000         |
|              | GasOfMinGasPriceOp                     |                    |                         | staking/staking.go/GasOfMinGasPriceOp/50_000        |
|              | DefaultMinGasPrice                     | test.min-gas-price |                         | staking/staking.go/DefaultMinGasPrice/10e9          |
|              | MinGasPriceDeltaRateInBlock            |                    |                         | staking/staking.go/MinGasPriceDeltaRateInBlock/5    |
|              | MinGasPriceUpperBound                  |                    |                         | staking/staking.go/MinGasPriceUpperBound/500e9      |
|              | MinGasPriceLowerBound                  |                    |                         | staking/staking.go/MinGasPriceLowerBound/1e9        |
|              | NumBlocksToClearMemory                 |                    |                         | staking/watcher.go/NumBlocksToClearMemory/1000      |
|              | WaitingBlockDelayTime                  |                    |                         | staking/watcher.go/WaitingBlockDelayTime/2          |
|              |                                        |                    |                         |                                                     |
|              |                                        |                    |                         |                                                     |
