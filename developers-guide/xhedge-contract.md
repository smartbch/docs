# XHedge: a smart contract for a DeFi-Friendly PoS

In the white paper of smartBCH, we wrote: "During an epoch, BCH owners prove their ownerships of time-locked UTXOs and use the values of these UTXO to vote for a validator; whereas mining pools use coinbase transactions to vote...At the first phase after Smart Bitcoin Cash's launch, only hash power is used for electing validators. Locking BCH at mainnet for staking will be implemented later and take effect in a future hard fork." These words describe a popular PoS scheme requiring the holders to "lock" their coins for some time. It has an obvious disadvantage: when the holders vote for a validator, they will lost their opportunities of depositing the coins in DeFi and earning some benefits.

After the launching of smartBCH, we the developers have been thinking about how to implement staking without this disadvantage. And the solution is surprisingly simple: the voters must be the guys who would like to "long Bitcoin Cash and short the world".

The PoS scheme of smartBCH begins with a smart contract named XHedge which extends the function of AnyHedge (a famous Bitcoin Cash futures contract). Then it combines XHedge and the concept of coin-day to enable voting.

Just like AnyHedge, XHedge needs one or more oracles to submit the price of BCH (relative to USD) onto smartBCH.

Suppose now BCH's price is `P0` and Bob wants to use XHedge to divide some BCH into a pair of LeverNFT/HedgeNFT.  He must provide the following arguments:

1. The initial collateral rate: `CR0`
2. The minimum collateral rate: `CRmin`
3. The value contained in the HedgeNFT (measured in USD): `Vh`
4. Penalty on closeout: `Pc`
5. Mature time: `MT`
6. A validator Bob would like to support
7. The price oracle which this pair of NFTs will trust

And then XHedge will deduct some BCH from Bob's account and lock them. The locked Amount is `A=(1+CR0)*Vh/P0`. After that Bob get a LeverNFT and a HedgeNFT, which can be transferred to other persons. In some scenarios, these NFT can be both burnt and the BCH locked because of them will be liquidated:

1. Before the mature time, if the price drops to `P1` and the locked BCH cannot meet the minimum collateral rate (`A < (1+CRmin)*Vh/P1`), then the owner of HedgeNFT can initiate liquidation.  The owner of HedgeNFT can get `min(A, (1+Pc)*Vh/P1)` and the owner of LeverNFT, `max(0, A-(1+Pc)*Vh/P1)`. 
2. After the mature time `MT`, any owner of these two NFTs can initiate liquidation. At the liquidation moment, if BCH's price is `P2`, then the owner of HedgeNFT can get `min(A, Vh*P2)` and the owner of LeverNFT, `max(0, A-Vh*P2)`. The owner of HedgeNFT secures the value of her asset, while the owner of LeverNFT enlarges her risk and benefit.
3. At any time, if both LeverNFT and HedgeNFT belong to the same account, then this account can get all the locked BCH by burning both NTF tokens.

The owner of LeverNFT can increase or decrease the locked BCH amount `A`:

1. At any time, she can deposit more BCH to enlarge A: add margin to avoid closeout
2. When the current price `P` is large enough for `P>P0*CR0`, she can withdraw some BCH to shrink A (reduce the margin), as long as A is no less than `(1+CR0)*Vh/P` after withdrawing. And, from the coins withdrawn by her, 0.5% is deducted and paid to the owner of HedgeNFT as a compensation fee.

Now we'd like to add some function to XHedge to enable voting. 

XHedge will record how long the coins have been locked because of a pair of NFTs, which is used to calculate the accumulated coin-day. One coin-day means one BCH is locked for 24 hours. Anyone can send transaction to:

1. Use this pair of NFT to vote for the supported validator, and the voting power equals the accumulated coin-days.
2. And, at the same time, reset the accumulated coin-days to zero.

Since anyone can send transactions to reset the accumulated coin-days, it is very hard for the LeverNFT's owner to accumulate a lot of coin-days. It will be very common for a validator to scan HedgeNFTs which are supporting her and turn the accumulated coin-days into votes before the next epoch.

XHedge will be implemented in EVM bytecode (compiled from solidity), just like any other smart contract. Inside its storage the accumulated coin-days voted for each validate are recorded. When switching to another epoch, the staking logic of smartBCH will scan these records for voting information and then clears these records.

Who has the rights to change the supported validator? The owner of the LeverNFT. Because only she is a stakeholder of BCH, while the owner of HedgeNFT is actually holding USD.

After splitting his BCH into LeverNFT and HedgeNFT, Bob can deposit the NFTs into DeFi for earning. At the same time, the LeverNFT is continuously voting for the validator he supports, as long as the DeFi application which manages the LeverNFT does not change the supported validator.

To sum up, smartBCH's PoS scheme as the following advantages:

1. Having voters for the validators be long-positions, it creates an even stronger alignment of incentives compared to "just" locking coins
2. The BCH involved in DeFi applications can also be used for voting
3. Allows the holders to borrow stable tokens by taking BCH as collateral
4. The LeverNFT/HedgeNFT are always created and burnt in pair, you do not have to worry about liquidity at closeout moments
5. Decentralized stable coins and other DeFi applications can be built upon HedgeNFT and/or LeverNFT.

