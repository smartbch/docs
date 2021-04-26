# SmartBCH TestNet Doc

To deploy a testnet, we need three steps:

1. Install the dependencies and build binary of smartbchd
2. Generate one unique genesis.json file
3. Start the nodes using this unique genesis.json file

## About machine

We support machine with 2 core, 8G memory and 64G disk.

## Build smartbchd

Please refer to [this document](https://docs.smartbch.org/smartbch/deverlopers-guide/runsinglenode) and stop after step 4 (do not run step 5).

Now you have got the smartbchd binary.

## Generate genesis.json

#### step 1. Initialize the working directory

One of the nodes must be picked for outputing the genesis.json file. We refer to this node as "generator" and the other nodes, "collaborator".

The collaborators use the following command to initialize the chain. You can use any favorite id to replace the following "freedomMan".

```
./build/smartbchd init freedomMan --chain-id 0x2711
```

The generator use the following command to initialize the chain.

```
./build/smartbchd init freedomMan --chain-id 0x2711 \
  --init-balance=10000000000000000000 \
  --test-keys="37929f578acf92f58f14c5b9cd45ff28c2868c2ba194620238f25d354926a287"
```

#### step 2. send generated genesis validator to generator

Use following command to generate a new the hex-format private key for validator

```
./build/smartbchd gen-test-keys -n 1
```

Use the `generate-genesis-validator` command to generate a validator, with the validator's hex-format operating private key as the argument.

```
./build/smartbchd generate-genesis-validator 37929f578acf92f58f14c5b9cd45ff28c2868c2ba194620238f25d354926a287

7b2241646472657373223a5b3133312c3137372c3232362c33382c3134322c3135312c3130392c32302c3230352c3233312c3139342c35392c3137302c3134382c3133362c3131362c342c3235342c3131332c3136315d2c225075626b6579223a5b33382c3131362c31312c3132322c32342c31332c34332c3233392c3231382c38392c3234392c36332c3132312c31332c3134332c3233372c35342c31342c33322c3233372c3230302c3130322c3231312c34342c32392c39332c3132392c322c39302c3232392c3234342c3135375d2c22526577617264546f223a5b302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c305d2c22566f74696e67506f776572223a312c22496e74726f64756374696f6e223a2267656e657369735f76616c696461746f72222c225374616b6564436f696e73223a5b302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c35342c35332c3230312c3137332c3139372c3232322c3136302c302c305d2c2249735265746972696e67223a66616c73657d
```

⚠️ All the collaborators send this command's output to the generator. The output contains the operator's address, consensus pubkey, voting power and staking amount.

#### step 3. send p2p seed to generator

Using the following command to start smartbchd, and kill it after two seconds using "Ctrl-C".

```
./build/smartbchd start
```

Search the string "This Node ID" in the output log of the killed smartbchd. After this string, there is a node ID. Like following:

```
This Node ID: f392e4c7f2024e4f7d51a2d4f8cf08ddc4ac4532
```

The, compose a p2p seed with the node ID, IP address of the server and the port number 26656. Like:

```
f392e4c7f2024e4f7d51a2d4f8cf08ddc4ac4532@45.32.38.25:26656
```

The collaborators send their p2p seeds to the generator.


## Start the testnet

#### step 4. collect validators information and p2p seeds

The generator collects the outputs from collaborator, and add the information into genesis.json, one by one.

```
./build/smartbchd add-genesis-validator 7b2241646472657373223a5b3133312c3137372c3232362c33382c3134322c3135312c3130392c32302c3230352c3233312c3139342c35392c3137302c3134382c3133362c3131362c342c3235342c3131332c3136315d2c225075626b6579223a5b3134312c39372c34312c39372c3138322c33352c3232302c3139392c3232302c31382c37352c38382c3137322c3135312c38322c3133332c39332c39312c3134342c3134362c3233322c32392c3231312c3231332c3135382c3233382c3232322c3134362c3231372c3138302c33372c3130355d2c22526577617264546f223a5b302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c305d2c22566f74696e67506f776572223a312c22496e74726f64756374696f6e223a2267656e657369735f76616c696461746f72222c225374616b6564436f696e73223a5b302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c302c35342c35332c3230312c3137332c3139372c3232322c3136302c302c305d2c2249735265746972696e67223a66616c73657d
```

Repeat the above command till all the collaborators' information are added.

Now, a genesis.json file is generated, which contains an account with all the native tokens and the information of all the validators.

The generator distributes this genesis.json file to the collaborators. And the collaborators use this file to overwrite `~/.smartbchd/config/genesis.json`.

Also, the generator puts the collected seeds into the config.toml file, which locates at `~/.smartbchd/config/config.toml`.


The generator open the config.toml file and search for `seeds = ""`. Then add the collected seeds in, using commas to seperate the seeds, like this: 

```
seeds = "f392e4c7f2024e4f7d51a2d4f8cf08ddc4ac4532@45.32.38.25:26656,4ac453f3cf08ddc292e4c7f2024e4f7d51a2d4f8@54.23.83.52:26656"
```

Then the generator send this line to all the collaborators, who replaces the seeds line in their `~/.smartbchd/config/config.toml`.

#### step 5. Start It!

All the collaborators must make sure they update `~/.smartbchd/config/genesis.json` and `~/.smartbchd/config/config.toml` using the information sent by the generator.

Then, open port 26656, 8545,8546 on your machine.

Final, all the nodes (including collaborators and the generator) run the following command:

```
./build/smartbchd start
```

After running this command, if the network is OK, we'll see the log showing new blocks are generated.

⚠️Please use some process management tool such as systemd to manage smartbchd.


