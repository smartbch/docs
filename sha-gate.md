# Decentralized Cross-Chain Bridge

## SHA-Gate: a sidechain bridge for Bitcoin Cash

This document describes a mechanism named "SHA-Gate" which transfers BCH between the Bitcoin Cash main chain and a sidechain.  It is decentralized, non-custodian, miner-supervised and fully implemented with Bitcoin Cash's script bytecode. It does not require any consensus change of Bitcoin Cash, nor rely on operators' honesty for asset security.

 ### Light-Clients are not safe enough for crossing chain

Many people believe that cross chain bridge is good enough to be as secure as a light client of the host chain. This is a wrong belief.

The basic idea of light clients is to trust the miners of PoW chain (or the validators of PoS chain), instead of verifying the transactions yourself. This means the miners and validators can be much more harmful and dangerous on the guest chain than on the host chain.

The worst thing that miners can do on Bitcoin Cash is to reorg the chain for double-spend. And the worst thing of the validators on smartBCH is double-signing. The miners and validators cannot make the other full-node clients accept fake transactions, because they verify all transactions. But they can make light clients accept fake transactions.

If smartBCH use an embedded BCH light client to verify the cross-chain transfers from main chain, a malicious attacker would like to rent hash power to mine some BCH blocks containing fake cross-chain transactions and submit this fork onto smartBCH, as long as these fake transactions can gain them more profit than the rent fee of hash power. These BCH blocks mined by the attacker are only submitted to smartBCH, because their fake transactions are invalid on the main chain.

If we use a covenant on BCH to implement smartBCH's light client for cross-chain transfers to the main chain, a malicious attacker would like to bribe the validators to sign fake smartBCH cross-chain transactions to unlock coins on BCH main chain, as long as it can gain more than the slash punishment for double-signing.

So the SHA-Gate's design is not based on light clients, instead, it depends on power balance of several parties.

### The Design of SHA-Gate

A cross-chain bridge has two directions: to the sidechain and from the sidechain.

At the direction to sidechain, we decided to make smartBCH's clients to listen to a BCH full-node client for main chain blocks, instead of using light clients. Thus it can be secure by nature.

At the direction from sidechain, the bridge relies on a federation for operation, and the miners for supervision. If Alice want to transfer coins from smartBCH back to main chain, it needs the following four steps:

1. Alice sends a request on smartBCH
2. A operator notices this request and initialize an unlocking proposal on BCH main chain.
3. Optionally, the miners vote on this proposal.
4. If the miners approve this proposal or they never vote for it, Alice can receive the unlocked coins on BCH main chain.

A miner can vote "yes" or "no" to a proposal. When "yes" votes reaches 30 or "no" votes reaches 30, the voting process ends. When no miner votes for it for more than 150 blocks, the voting process also ends. Please note these numbers (30 and 150) are not final and may change.

Any operator in the federation can initialize unlocking proposals, to avoid single point failure. 

If an operator is corrupt (or gets its private key stolen), it would send illegal unlocking proposals. In such cases, the miners must vote to stop it. As long as one of operators‘ keys is safe, the locked coins can be migrated to another set of UTXOs kept by honest operators. This migration can finally succeed if we have more honest miners than malicious miners.

A malicious miner can vote "no" to a legal proposal, but it cannot get any profit from it. The honest miners will vote "yes" to defeat him.

### The Implementation of SHA-Gate

All the coins existing in smartBCH are locked in a special kind of BCH UTXOs, named as cc_covenant (cc is short for cross-chain). [Covenants](https://cashscript.org/docs/guides/covenants) are a type of contracts enforcing rules on how the funds can be spent: not only who and when can spend the funds, but also what they can do with them. Luckily, virtual machine of Bitcoin Cash is powerful enough to implement the operation and supervision in cc_covenant.

#### Send coins to smartBCH

When a P2PKH address sends some coins into a cc_covenant, it means these coins are sent onto smartBCH. 

Alice wants to send coins from BCH onto smartBCH. So she sends a transaction with one or more UTXOs as the input and one cc_covenant as the output. There are two ways to indicate the receiver on smartBCH. One way is adding an extra OP_RETURN output to directly specify the receiver's address. The other way is by inferencing: The first input must be a P2PKH UTXO. And since this transaction reveals the secp256k1 public key of this P2PKH address, a smartBCH address can be calculated by hashing this public key with Keccak256, and the unlocked coins will be deposited to this address.

There will be a lower bound of the value contained in a cc_covenant, to prevent dusting attacks.

This process is performed by all the smartBCH's full clients. It needs no party's manual operation, instead, it is fully automatic. Every smartBCH node must connect to a BCHN RPC server to fetch the latest blocks and transactions on BCH. Once it finds a new cc_covenant is created in a predefined way, it unlocks the same amount of BCH on smartBCH sidechain.

#### Send coins from smartBCH

Sending coins from smartBCH to BCH main chain needs four steps, and in the latter three steps, different parties call different functions of cc_covenant. The source code of cc_covenant is attached in the appendix of this document. Here we briefly introduce how cc_covenant works.

The cc_covenant has several state variables which control how the functions behave, they are:

- `operKey0`, `operKey1` and `operKey2`: These are the operators' public keys. They are initialized when creating cc_covenant. If they are not initialized to predefined value, smartBCH will not take the coins locked in this cc_covenant as cross-chain coins.
- `receiver`: It is initialized as zero. When the operator initialize an unlock proposal, it will change `receiver` to the public key specified by Alice on smartBCH.
- `noBytes` and `yesBytes`: These are the voting counters. They must be initialized as 10001 and 10000. The operators reset them to zero when initializing an unlock proposal. Only miners can change them during voting.

The cc_covenant has three functions:

1. **`initUnlock`**: This function can only be called by the operators. It set the receiver's pubkey and clear the vote counters to zero.

2. **`vote`**: This function can only be called by the miners. The miner must use an output of a coinbase transaction as the second input of the vote transaction, whose first input is the covenants itself. In the coinbase transaction, an OP_RETURN output must contain this covenant's ID (`tx.outpoint` in the source code), which indicates this coinbase transaction wants to vote for this covenant. To vote for a covenant, a miner must use a coinbase transaction whose height is greater than the cc_covenant's height. Thus, one coinbase transaction can vote only one time for one proposal. While voting for multiple proposals using one coinbase transaction is possible.

3. **`finishUnlock`**: With a signature generated with her private key, Alice can spend a covenant if the vote result is yes and there have been 150 blocks since last vote of this covenant. If there is no vote at all, Alice can spend it 150 blocks later after the operator initializes the proposal.

### Appendix

#### Source code of cc_covenant

Following is the [cashscript](https://cashscript.org) source code for cc_covenant (It may have bugs and is prone to change. Here we use it only for demonstrating the idea):

```javascript
contract cc_covenant(pubkey operKey0, pubkey operKey1, pubkey operKey2, pubkey receiver, bytes4 noBytes, bytes4 yesBytes) {
   // initialize an unlocking proposal
   function initUnlock(sig s, pubkey pk, bytes33 newReceiver) {
      require(checkSig(s, pk));
      require(pk == operKey0 || pk == operKey1 || pk == operKey2);
      // we want to ensure this utxo has been voted to stay or nobody voted in last 300 blocks
      // The following if-clause is actually requiring int(noBytes) > 30 || tx.age >= 300
      if(int(noBytes) <= 30) {
         require(tx.age >= 300);
      }

      // update receiver and clear vote count
      bytes newContract = 0x0400000000040000000021 + newReceiver + tx.bytecode.split(44)[1];// 5+5+34
      bytes8 amount = bytes8(int(bytes(tx.value)) - 1000); // 1000 is hardcoded fee
      bytes32 out = new OutputP2SH(amount, hash160(newContract));
      require(hash256(out) == tx.hashOutputs);
   }

   // miners vote for whether this utxo can be sent or not
   function vote(sig s, pubkey pk, bytes coinbaseTx, bytes32 coinbaseTxID, bytes4 coinbaseVout, int position, bool agree) {
      require(checkSig(s, pk)); //covenant need this statement
      require(int(noBytes) < 30 && int(yesBytes) < 30); // no side reaches 30 votes
      // make sure only a miner can call this function
      require(coinbaseTx.split(82)[0] == 0x01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff);
      require(hash256(coinbaseTx) == coinbaseTxID);
      require(hash256(tx.outpoint + coinbaseTxID + coinbaseVout) == tx.hashPrevouts);
      require(coinbaseTx.split(position)[1].split(36)[0] == tx.outpoint);

      bytes4 noBytesUpdate = noBytes;
      bytes4 yesBytesUpdate = yesBytes;
      if(agree) {
         yesBytesUpdate = bytes4(int(yesBytes) + 1);
      } else {
         noBytesUpdate = bytes4(int(noBytes) + 1);
      }

      // update vote count
      bytes newContract = 0x04 + yesBytesUpdate +
                          0x04 + noBytesUpdate + tx.bytecode.split(10)[1]; // 5+5
      bytes8 amount = bytes8(int(bytes(tx.value)) - 1000); // 1000 is hardcoded fee
      bytes32 out = new OutputP2SH(amount, hash160(newContract));
      require(hash256(out) == tx.hashOutputs);
   }

   // finish the unlocking process
   function finishUnlock(sig s) {
      require(checkSig(s, receiver));
      require(tx.age >= 150); // nobody voted in last 150 blocks
      require(int(yesBytes) >= int(noBytes));
   }
}
```

This covenant compiles into 194 operations and 359 bytes, which can fit into the [201&520 limitation](https://bitcoincashresearch.org/t/raising-the-520-byte-push-limit-201-operation-limit/282).

