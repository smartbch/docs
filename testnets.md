# Testnets for smartBCH

You can test your DApp using a [local single-node testnet](deverlopers-guide/runsinglenode.md) if you want to set one up. In most cases, though, you might not need to set up a testnet yourself. Instead, you can using an existing testnet. Here are the running testnets you can utilize.

You can run tests with [metamask](deverlopers-guide/test-using-metamask.md), [truffle](deverlopers-guide/deploy-contract-using-truffle.md), or [remix](deverlopers-guide/deploy-contract-using-remix.md).


### smartBCH-T1

This is the first testnet for smartBCH. The chain ID is 0x2711. You can use the following JSON-RPC nodes:

1. http://106.75.244.31:8545
2. http://106.75.214.131:8545
3. http://135.181.219.10:8545

Test coin faucet can be found at http://moeing.tech:8080/faucet

In this testnet, the gas price can be as low as zero.

To join this testnet as a non-validator node, follow the steps below:

First, build the latest binary by running the step 0, 1, 2, 3 and 4 of [this document](deverlopers-guide/runsinglenode.md).

Second, prepare the working directory:

```bash
cp ~/smart_bch/smartbch/smartbchd ~/build/smartbchd

~/build/smartbchd init freedomMan --chain-id 0x2711

cat > ~/.smartbchd/config/genesis.json <<EOF
{"genesis_time":"2021-04-28T08:52:30.924811088Z","chain_id":"0x2711","initial_height":"1","consensus_params":{"block":{"max_bytes":"22020096","max_gas":"-1","time_iota_ms":"1000"},"evidence":{"max_age_num_blocks":"100000","max_age_duration":"172800000000000","max_bytes":"1048576"},"validator":{"pub_key_types":["ed25519"]},"version":{}},"app_hash":"","app_state":{"validators":[{"Address":[131,177,226,38,142,151,109,20,205,231,194,59,170,148,136,116,4,254,113,161],"Pubkey":[216,67,236,41,175,121,7,192,158,182,170,217,10,110,107,227,136,73,179,237,32,89,47,137,235,159,143,117,10,4,205,166],"RewardTo":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"VotingPower":10,"Introduction":"genesis_validator","StakedCoins":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,54,53,201,173,197,222,160,0,0],"IsRetiring":false},{"Address":[77,107,212,170,94,71,12,121,49,45,142,134,13,33,235,187,35,24,138,28],"Pubkey":[9,59,7,178,72,63,73,82,107,168,156,253,25,170,107,35,79,46,81,231,61,155,95,29,164,45,228,103,53,119,136,48],"RewardTo":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"VotingPower":1,"Introduction":"genesis_validator","StakedCoins":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,54,53,201,173,197,222,160,0,0],"IsRetiring":false},{"Address":[59,65,43,120,81,44,91,200,255,60,222,186,33,102,94,22,34,52,199,115],"Pubkey":[27,215,102,227,235,52,63,129,170,212,140,91,27,61,3,146,116,113,4,211,15,195,76,160,25,34,5,178,87,189,241,196],"RewardTo":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"VotingPower":1,"Introduction":"genesis_validator","StakedCoins":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,54,53,201,173,197,222,160,0,0],"IsRetiring":false}],"alloc":{"0x83b1e2268e976d14cde7c23baa94887404fe71a1":{"balance":"0x204fce5e3e25026110000000","secretKey":"0x37929f578acf92f58f14c5b9cd45ff28c2868c2ba194620238f25d354926a287"}}}}
EOF

cp ~/.smartbchd/config/config.toml ~/tmp

gawk '$1!="seeds" {print $0} $1=="seeds" {print "seeds = \"63211024f412d931521b1b64e2606510c13b3f64@139.180.189.205:26656,4c81dfb478831d006411769db2939f39a85058ec@45.32.38.25:26656,6b30dd5a93b343f1e1804caf06d027c31e3f442f@158.247.197.98:26656,bb298794e8fd14e7eccd97a99915291743e591e4@106.75.244.31:26656,bb298794e8fd14e7eccd97a99915291743e591e4@106.75.244.31:26656,2533226d85037357b933c77db179badb0d00898c@106.75.214.131:26656,6e278aebce4e5b00ebf261d996f8e46fea134738@47.242.105.251:26656\""}' ~/tmp > ~/.smartbchd/config/config.toml

rm ~/tmp
```

Last, start smartbchd:

```bash
~/build/smartbchd start
```

### smartBCH-T1a

This is the another testnet for smartBCH. The chain ID is 0x2711. You can use the following JSON-RPC nodes:

1. https://moeing.app:9545

Test coin faucet can be found at http://moeing.tech:8081/faucet

In this testnet, the gas price can be as low as zero.

To join this testnet as a non-validator node, follow the steps below:

First, build the latest binary by running the step 0, 1, 2, 3 and 4 of [this document](deverlopers-guide/runsinglenode.md).

Second, prepare the working directory:

```bash
cp ~/smart_bch/smartbch/smartbchd ~/build/smartbchd

~/build/smartbchd init freedomMan --chain-id 0x2711

cat > ~/.smartbchd/config/genesis.json <<EOF
{"genesis_time":"2021-05-10T08:12:51.389723498Z","chain_id":"0x2711","initial_height":"1","consensus_params":{"block":{"max_bytes":"22020096","max_gas":"-1","time_iota_ms":"1000"},"evidence":{"max_age_num_blocks":"100000","max_age_duration":"172800000000000","max_bytes":"1048576"},"validator":{"pub_key_types":["ed25519"]},"version":{}},"app_hash":"","app_state":{"validators":[{"Address":[131,177,226,38,142,151,109,20,205,231,194,59,170,148,136,116,4,254,113,161],"Pubkey":[128,218,60,236,176,123,26,23,186,131,84,63,104,104,11,183,111,237,49,149,183,180,131,161,47,166,241,210,164,50,68,205],"RewardTo":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"VotingPower":1,"Introduction":"genesis_validator","StakedCoins":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,54,53,201,173,197,222,160,0,0],"IsRetiring":false}],"alloc":{"0x83b1e2268e976d14cde7c23baa94887404fe71a1":{"balance":"0x204fce5e3e25026110000000","secretKey":"0x37929f578acf92f58f14c5b9cd45ff28c2868c2ba194620238f25d354926a287"}}}}
EOF

cp ~/.smartbchd/config/config.toml ~/tmp

gawk '$1!="seeds" {print $0} $1=="seeds" {print "seeds = \"25f2aa2d2aa5b09f1867ab88ff3e284e035ab511@158.247.192.195:26656\""}' ~/tmp > ~/.smartbchd/config/config.toml

rm ~/tmp
```

Last, start smartbchd:

```bash
~/build/smartbchd start
```