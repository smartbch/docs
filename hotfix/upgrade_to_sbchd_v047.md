# Upgrade smartbchd to 0.4.7

A vulnerability has been found and patched for smartbchd. More than 2/3 of the validators have been patched, so the chain and the assets are safe now.

If you are running nodes with smartbchd-v0.4.6p1, please upgrade them to v0.4.7 to keep the same consensus with most of the validators.

```
# get the image
docker pull smartbch/smartbchd:v0.4.7

# check the version
docker run --rm smartbch/smartbchd:v0.4.7 version

# stop the old container
docker stop sbchd
docker container rm sbchd

# start a new one
sudo docker run \
  -v ~/.smartbchd:/root/.smartbchd \
  -p 0.0.0.0:8545:8545 \
  -p 0.0.0.0:8546:8546 \
  -p 0.0.0.0:26656:26656 \
  --ulimit nofile=65535:65535 \
  --log-opt max-size=200m \
  --name sbchd \
  -d smartbch/smartbchd:v0.4.7 start \
  --log_level='json-rpc:debug,watcher:debug,*:info' \
  --http.api='eth,web3,net,txpool,sbch,debug'
  
# check the logs
docker logs -f -n100 sbchd
```


