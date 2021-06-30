# Testnets for smartBCH

You can test your DApp using a [local single-node testnet](developers-guide/runsinglenode.md) if you want to set one up. In most cases, though, you might not need to set up a testnet yourself. Instead, you can using an existing testnet. Here are the running testnets you can utilize.

You can run tests with [metamask](developers-guide/test-using-metamask.md), [truffle](developers-guide/deploy-contract-using-truffle.md), or [remix](developers-guide/deploy-contract-using-remix.md).

### smartBCH-T1a (not active)

~~This is a testnet for smartBCH with nodes supports https. The chain ID is 0x2711. You can use the following JSON-RPC nodes:~~

1. ~~https://moeing.app:9545~~
2. ~~http://moeing.app:8545~~
3. ~~https://moeing.tech:9545~~
4. ~~http://moeing.tech:8545~~
5. ~~https://t.smartbch.games:9546~~

~~Test coin faucet can be found at http://moeing.tech:8081/faucet~~

~~In this testnet, the gas price can be as low as zero.~~

~~To join this testnet as a non-validator node, follow the steps below:~~

~~First, build the latest binary by running the step 0, 1, 2, 3 and 4 of [this document](developers-guide/runsinglenode.md).~~

~~Second, prepare the working directory:~~

```bash
cp ~/smart_bch/smartbch/smartbchd ~/build/smartbchd

~/build/smartbchd init freedomMan --chain-id 0x2711

cat > ~/.smartbchd/config/genesis.json <<EOF
{"genesis_time":"2021-05-10T08:12:51.389723498Z","chain_id":"0x2711","initial_height":"1","consensus_params":{"block":{"max_bytes":"22020096","max_gas":"-1","time_iota_ms":"1000"},"evidence":{"max_age_num_blocks":"100000","max_age_duration":"172800000000000","max_bytes":"1048576"},"validator":{"pub_key_types":["ed25519"]},"version":{}},"app_hash":"","app_state":{"validators":[{"Address":[131,177,226,38,142,151,109,20,205,231,194,59,170,148,136,116,4,254,113,161],"Pubkey":[128,218,60,236,176,123,26,23,186,131,84,63,104,104,11,183,111,237,49,149,183,180,131,161,47,166,241,210,164,50,68,205],"RewardTo":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"VotingPower":1,"Introduction":"genesis_validator","StakedCoins":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,54,53,201,173,197,222,160,0,0],"IsRetiring":false}],"alloc":{"0x83b1e2268e976d14cde7c23baa94887404fe71a1":{"balance":"0x204fce5e3e25026110000000","secretKey":"0x37929f578acf92f58f14c5b9cd45ff28c2868c2ba194620238f25d354926a287"}}}}
EOF

cp ~/.smartbchd/config/config.toml ~/tmp

gawk '$1!="seeds" {print $0} $1=="seeds" {print "seeds = \"25f2aa2d2aa5b09f1867ab88ff3e284e035ab511@158.247.192.195:26656,ecda5896373d6d2e8e22d2d542fd1daf4f4a003d@52.32.81.115:26656,0f3563ae60f7aff5f5eca567ef505fc79d5b54ef@207.148.84.37:26656\""}' ~/tmp > ~/.smartbchd/config/config.toml

rm ~/tmp
```

~~Last, start smartbchd:~~

```bash
~/build/smartbchd start
```


### smartBCH-billiongas

This is a testnet for smartBCH to demonstrate its billion gas capacity. The chain ID is 0x2711. You can use the following JSON-RPC nodes:

1. http://billiongas.org:8545
2. http://billiongas.net:8545
3. http://billiongas.io:8545
4. http://billiongas.cash:8545

In this testnet, the gas price can be as low as zero.

Test coin faucet can be found at http://34.92.91.11:8080/faucet

To join this testnet as a non-validator node, follow the steps below:

First, build the latest binary by running the step 0, 1, 2, 3 and 4 of [this document](developers-guide/runsinglenode.md).

Second, prepare the working directory:

```bash
cp ~/smart_bch/smartbch/smartbchd ~/build/smartbchd
cd ~
rm -rf .smartbchd
~/build/smartbchd init freedomMan --chain-id 0x2711
wget https://github.com/smartbch/artifacts/releases/download/v0.0.1/dot.smartbchd.tgz
tar zxvf dot.smartbchd.tgz
cp -rf dot.smartbchd/* .smartbchd/
```

Last, start smartbchd. Since this "billiongas" testnet needs a lot of SSD space, you'd better use the `--home` option to specify another location for the data directory.

```bash
export DIR=/path/to/a/dir/in/big/disk
mkdir $DIR
mv ~/.smartbchd $DIR/
ulimit -n 65536
~/build/smartbchd start --home=$DIR/.smartbchd
```

### smartBCH-T2

This is a testnet for smartBCH with votes from a BCHN testnet, which has a bitcoincashnode client which mines with CPU.The chain ID is 0x2711. You can use the following JSON-RPC nodes:

1. http://35.220.203.194:8545
2. http://34.92.91.11:8545
3. http://34.85.10.192:8546

Test coin faucet can be found at http://moeing.tech:8081/faucet

In this testnet, the gas price can be as low as zero.

To join this testnet as a non-validator node, follow the steps below:

First, build the latest binary by running the step 0, 1, 2, 3 and 4 of [this document](developers-guide/runsinglenode.md).

Second, prepare the working directory:

```bash
cp ~/smart_bch/smartbch/smartbchd ~/build/smartbchd
cd ~
rm -rf .smartbchd
~/build/smartbchd init freedomMan --chain-id 0x2711
wget https://github.com/smartbch/artifacts/releases/download/v0.0.2/dot.smartbchd.tgz
tar zxvf dot.smartbchd.tgz
cp -rf dot.smartbchd/* .smartbchd/
```

Last, start smartbchd. 

```bash
./smartbchd start --mainnet-url=http://34.150.125.124:8332 \
  --mainnet-user=test \
  --mainnet-password=test \
  --mainnet-genesis-height=10900 \
  --log-validators=true \
  --smartbch-url=http://35.220.203.194:8545 \
  --watcher-speedup=true 

```

If you want to join the underlying BCH testnet, here is the configuration file for bitcoincashnode:

```
regtest=1

[regtest]

bind=0.0.0.0
port=8331
rpcbind=0.0.0.0
rpcport=8332

zmqpubhashtx=tcp://0.0.0.0:8333
zmqpubhashblock=tcp://0.0.0.0:8333

rpcuser=test
rpcpassword=test
rpcthreads=4

rpcallowip=0.0.0.0/0

whitelistrelay=0

addnode=47.115.171.70:28331
```

