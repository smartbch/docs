# How to activate a genesis validator

Please refer to [this document](https://docs.smartbch.org/smartbch/deverlopers-guide/runsinglenode) and stop after step 8 (do not run step 9).

⚠️Now,  give the data printed at step 8 to smartBCH team please.

Waiting for......

After smartBCH team give you a genesis file, you can continue with below steps:

#### Step 1: copy basic files

```
cp ./priv_validator_key.json ~/.smartbchd/config/
cp ./smartBCH_team_genesis.json ~/.smartbchd/config/genesis.json
```



#### Step 2: config p2p seeds

Waiting for......

smartBCH team will give you a seeds string.

write the seeds into `config.toml` file, which locates at `~/.smartbchd/config/config.toml`.


open the `config.toml file` and search for `seeds = ""`. Then add the collected seeds in, using commas to seperate the seeds, like this: 

```
seeds = "f392e4c7f2024e4f7d51a2d4f8cf08ddc4ac4532@45.32.38.25:26656,4ac453f3cf08ddc292e4c7f2024e4f7d51a2d4f8@54.23.83.52:26656"
```



#### Step 3: start node

```
./build/smartbchd start
```



#### Step 4: activate validator

before you activate your genesis validator, try to get testnet BCH in your validator address, it need at least 

```
1000000000000000000000 bch
```

you can connect smartBCH team to get testnet bch, you can check your balance with below command:

replace `your_validator_address` with your genesis validator address

```
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["your_validator_address","latest"],"id":1}' -H "Content-Type: application/json" http://localhost:8545
```

After you have enough bch, you can follow below:

replace the `--validator-key` with your validator private key

repace the `--staking-coin` with `1000000000000000000000` or even more you have.

⚠️Keep your private key safe, and execute this command on a secure, offline machine

```
./build/smartbchd staking \
--validator-key=07427a59913df1ae8af709f60f536ddba122b0afa8908291471ca58c603a7447 \
--staking-coin=2000000000000000000000000 \
--nonce=0 \
--chain-id=0x2711
```

replace `--your_tx_data` with what hex string get above.

```
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_sendRawTransaction","params":["you_tx_data"],"id":1}' -H "Content-Type: application/json" http://localhost:8545
```

now, you had send a editValidator tx to staking contract，check the tx receipt

replace `your_tx_hash` with what the hex string you get above.

```
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["your_tx_has"],"id":1}' -H "Content-Type: application/json" http://localhost:8545
```

if the `status` displays `0x1`, congratulations, your genesis validator actived now.

