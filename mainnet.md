# Join the mainnet of smartBCH

This document introduces how to join the mainnet of smartBCH as a normal node (non-validator node).

Before you start, you must have a trusted server running bitcoincashnode's client with RPC enabled. The executable `smartbchd` will connect to it for querying staking information.

First, build the latest binary by running the step 0, 1, 2, 3 and 4 of [this document](developers-guide/runsinglenode.md).

Second, prepare the working directory:

```bash
cp ~/smart_bch/smartbch/smartbchd ~/build/smartbchd
cd ~
rm -rf .smartbchd
~/build/smartbchd init mynode --chain-id 0x2710
wget https://github.com/smartbch/artifacts/releases/download/v0.0.3/dot.smartbchd.tgz
tar zxvf dot.smartbchd.tgz
cp -rf dot.smartbchd/* .smartbchd/
```

Third, open the `~/.smartbchd/config/app.toml` file to modify the information of the bitcoincashnode's client with RPC enabled.

```
# BCH mainnet rpc url
mainnet-rpc-url = "http://ip-address:8332"

# BCH mainnet rpc username
mainnet-rpc-username = "<my user name>"

# BCH mainnet rpc password
mainnet-rpc-password = "<my password>"
```

Last, start smartbchd. 

```bash
./smartbchd start --mainnet-genesis-height=698502
```

