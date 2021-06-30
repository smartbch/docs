# Multi-Node TestNet With Fake BCH Mainnet Node

#### Dependencies

Please follow the guide for [multi-node testnet](./runmultinode.md). And do add the `--mainnet-url` option to specifiy a bitcoincashnode's RPC endpoint, which can be a real one or a fake one, just as following:

```
./smartbchd start --mainnet-url=http://node-ip-address:port-number
```



#### Running a Fake RPC Server for Testing

The `bchnode` tool mimics a real bitcoincashnode's RPC behavior. You can use it with the following steps:

##### Start the bchnode RPC Server

```
Git clone https://github.com/smartbch/testkit.git
cd bchnode
go run main.go &
```

##### Add a New Validator's public key and voting power

The format is `pubkey`-`votingPower`-`action`, where the action can be "add", "edit" or "retire".

```
cd scripts ;# there are some utility scripts in the directory testkit/bchnode/scripts
./pubkey.sh eeed4fae3da010e393efed2aacd271971fd2383fc68109a475d6c9ef65435d52-9-add
```

The `bchnode` produces blocks with fixed interval (default is 3 seconds) to vote for the validators.

##### Adjust block interval

To change the block interval to 10 seconds:

```
./interval.sh 10
```

##### Simulate a Block Reorg

```
./reorg.sh
```

The `bchnode` will simulate a fork at the height which is 8 blocks less than current height, and re-generate the recent 8 blocks.



#### The Suggested Scenarios for Test

1. Configure `bchnode` to follow the voting power and pubkeys specified in genesis.json
2. Keep the current voting power and pubkeys for three epochs.
3. Change the voting power setting of `bchnode`, such that at new epochs, the smartbchd follows the new voting power.
4. Run block reorg at `bchnode`, and smartbchd can work normally.
5. Add new validators in and let `bchnode` vote them to be active.
6. Restart smartbchd and it can also work fine.



#### smartBCH parameters for testing with bchnode

```
NumBlocksInEpoch       int64 = 30
NumBlocksToClearMemory int64 = 1000s
WaitingBlockDelayTime  int64 = 2s
SwitchEpochDelayTime   int64 = 10s
MinVotingPercentPerEpoch        = 10 //10 percent in NumBlocksInEpoch, like 2016 / 10 = 201
MinVotingPubKeysPercentPerEpoch = 34 //34 percent in active validators,
```

