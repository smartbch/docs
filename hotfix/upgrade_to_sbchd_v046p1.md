# Upgrade smartbchd to 0.4.6-p1


Because of a mis-configuration bug of v0.4.6 which incorrectly set a planning feature's enable height to 8000000 (it should be math.MaxInt64), smartbchd stoped at 7999999. We are very sorry for all the inconvenience!

We release a new version v0.4.6-p1 to fix this. This version added some hot-fix code to the staking logic and tendermint to allow a three-day interim one-validator period for chain-restarting, and the normal validators will come back after this period.

Now some of the smartbchd nodes have been updated and the RPC server https://rpc.smartbch.org can provide services.

If you are running nodes with smartbchd-v0.4.6, please upgrade them to v0.4.6-p1.

1) Install docker. Please follow the guide https://docs.docker.com/engine/install/ubuntu/ 

2) Pull smartbchd image:

```
sudo docker pull smartbch/smartbchd:v0.4.6-p1
sudo docker run --rm smartbch/smartbchd:v0.4.6-p1 version ;#this command will print its version
```

3) Stop the running smartbchd (if any)

4) remove cs.wal :
```
rm -rf path/to/.smartbchd/data/cs.wal
```

5) Modify the content of `path/to/.smartbchd/data/priv_validator_state.json` to:
```
{
  "height": "0",
  "round": 0,
  "step": 0
}
```

6) Modify the seeds configuration of `path/to/.smartbchd/config/config.toml`:

```
seeds = "2eedcab25ec235c660837a884af5c8914c2778b6@52.77.220.215:26656,f2e96f418033a615eefddd267df7010fc14700c9@13.212.74.236:26656,d96aafcbdc92dcb295ee28b050b47104a1749e23@13.229.211.167:26656"
```


7) Modify the app configuration of `path/to/.smartbchd/config/app.toml`:
```
watcher-speedup = false
```

8) Remove addrbook.json (you can also just move it to a different file name):

```
mv path/to/.smartbchd/config/addrbook.json path/to/.smartbchd/config/old_addrbook.json
```


9) Start docker. Following command is a reference:

```
sudo docker run \
  -v path/to/.smartbchd:/root/.smartbchd \
  -p 0.0.0.0:8545:8545 \
  -p 0.0.0.0:8546:8546 \
  -p 0.0.0.0:26656:26656 \
  --ulimit nofile=65535:65535 \
  --log-opt max-size=200m \
  --name sbchd \
  -d smartbch/smartbchd:v0.4.6-p1 start \
  --mainnet-genesis-height=698502 \
  --log_level='json-rpc:debug,watcher:debug,*:info' \
  --http.api='eth,web3,net,txpool,sbch,debug'
```

You can use the following command to watch the log of smartbchd:

```
sudo docker logs -f -n200 sbchd
```

