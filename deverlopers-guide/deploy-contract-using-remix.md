# Deploy contract using Remix

This article shows how to deploy smart contract using Remix IDE.

Please note in the following example we assume you are using a [local single-node testnet](./runsinglenode.md). Instead, if you want to use a remote node to provide JSON-RPC, just replace "localhost" with the node's IP address.


Step 1, open [Remix IDE](http://remix.ethereum.org/) in your browser:

![remix](../.gitbook/assets/remix.png)



Step 2, chose an environment. We can use MetaMask by selecting "Injected Web3" or connect to node directly by selecting "Web3 Provider". Take MetaMask for example, we neet to config it's network first:

![remix-metamask-network](../.gitbook/assets/remix-metamask-network.png)

Then, select "Injected Web3" to connect to MetaMask:

![remix-metamask-connect.png](../.gitbook/assets/remix-metamask-connect.png)



Step 3, create and compile your smart contract. We use Remix's Storage demo as example:

![remix-contract](../.gitbook/assets/remix-contract.png)

Compile your smart contract:

![image-20210414163154021](../.gitbook/assets/remix-compile.png)



Step 4, deploy compiled smart contract by clicking "Deploy" button:

![image-20210414163757696](../.gitbook/assets/remix-metamask-deploy.png)

Click "OK" button on MetaMask popup window:

![remix-metamask-deploy2](../.gitbook/assets/remix-metamask-deploy2.png)

