# SEP18: Blockchain cheques on smartBCH

* [SEP-18: Blockchain cheques on smartBCH](sep-18.md#blockchain-cheques-on-smartbch)
  * [1. Summary](sep-18.md#1--summary)
  * [2. Abstract](sep-18.md#2--abstract)
  * [3. Motivation](sep-18.md#3--motivation)
  * [4. Status](sep-18.md#4--status)
  * [5. Specification](sep-18.md#5--specification)
    * [5.1 Blockchain cheques](sep-18.md#51-blockchain-cheques)
      * [5.1.1 Methods](sep-18.md#511-methods)
        * [5.1.1.1 encryptionPubkeys](sep-18.md#5111-encryptionpubkeys)
        * [5.1.1.2 setEncryptionPubkey](sep-18.md#5112-setencryptionpubkey)
        * [5.1.1.3 unsetEncryptionPubkey](sep-18.md#5113-unsetencryptionpubkey)
        * [5.1.1.4 writeCheque](sep-18.md#5114-writecheque)
        * [5.1.1.5 revokeCheque](sep-18.md#5115-revokecheque)
        * [5.1.1.6 acceptCheque](sep-18.md#5116-acceptcheque)
        * [5.1.1.7 refuseCheque](sep-18.md#5117-refusecheque)
      * [5.1.2 Events](sep-18.md#512-events)
        * [5.1.2.1 SetEncryptionPubkey](sep-18.md#5121-setencryptionpubkey)
        * [5.1.2.2 UnsetEncryptionPubkey](sep-18.md#5122-unsetencryptionpubkey)
        * [5.1.2.3 NewCheque](sep-18.md#5123-newcheque)
        * [5.1.2.4 RevokeCheque](sep-18.md#5124-revokecheque)
        * [5.1.2.5 AcceptCheque](sep-18.md#5125-acceptcheque)
        * [5.1.2.6 RefuseCheque](sep-18.md#5126-refusecheque)
  * [6. License](sep-18.md#6-license)

## 1.  Summary

This SEP proposes an interface standard for sending and receiving blockchain cheques on smartBCH.

## 2.  Abstract

The following standard defines the implementation of APIs for blockchain cheque smart contracts. Such contracts hold the tokens the sender transfers and the receiver can choose to accept them or return them back to the sender.

## 3.  Motivation

In the physical world, you can write paper cheques to some payees. Cheques have richer information and features than normal cash payments. They can carry memos to explain the reason. They have deadlines to enforce the payees to accept them before a given date. The payees can choose to accept the funds or reject them by destroying the paper cheque.

In some scenarios, we would like to mimic paper cheques using smart contracts. Besides, blockchain cheques can provide more security by requiring passphrase and more privacy by encrypting memos.

## 4.  Status

This SEP is under draft.

## 5.  Specification

### 5.1 Blockchain cheques

**NOTES**:

* The following specifications use syntax from Solidity **0.8.6** \(or above\)
* All the listed functions and events MUST be implemented.

#### 5.1.1 Methods

**5.1.1.1 encryptionPubkeys**

```text
function encryptionPubkeys(address receiver) external view returns (uint);
```

Blockchain cheques can carry memos. To preserve privacy, all the memos must be encrypted with the receiver's public key for encryption. If a receiver does not book her public key for encryption in the contract, then nobody can send cheques with non-zero-length memos to her.

Given a reciever's address, the function `encryptionPubkeys` returns the corresponding 32-byte public key for encryption. It returns zero if the receiver does not book a public key.

**5.1.1.2 setEncryptionPubkey**

```text
function setEncryptionPubkey(uint pubkey, address referee) external;
```

A user uses `setEncryptionPubkey` to set `pubkey` as her public key for encryption. The argument `referee` is the address of the account who suggest this user to call `setEncryptionPubkey`. It can be set to zero if there is no referee at all.

**5.1.1.3 unsetEncryptionPubkey**

```text
function unsetEncryptionPubkey() external;
```

A user uses `unsetEncryptionPubkey` to cancel her public key for encryption. After that, this contract no longer allows sending any cheques with non-zero-length memos to her.

**5.1.1.4 writeCheque**

```text
function writeCheque(address payee,
			address coinType,
			uint96 amount,
			uint64 deadline,
			uint passphraseOrHashtag,
			bytes calldata memo) external payable;
function writeCheques(address[] calldata payeeList,
			address coinType,
			uint96 amount,
			uint64 deadline,
			uint[] calldata passphraseHashList,
			bytes[] calldata memoList) external payable;
```

The function `writeCheque` is used to write a cheque to the `payee`. The fund contained in the cheque must be an SEP20 token, whose address is `coinType`. The fund quantity is specified by `amount`. The `payee` must accept this cheque before the time `deadline`, which is UNIX timestamp, or this cheque will get expired.

A cheque can has a passphrase or a hash tag, according to the `passphraseOrHashtag` argument:
1. If this argument is zero, then this cheque has no passphrase nor hash tag.
2. Otherwise, if the most significant byte of this argument is 35 (the ascii code of "#"), then this cheque has a hash tag. Hash tag is usually a human-readable short string.
3. Otherwise, if the most significant byte of this argument is not 35, then the other 31 bytes of `passphraseOrHashtag` is a hash calculated from a passphrase. The passphrase can be transferred off-chain to the receiver, through e-mail, IM or other tools. The `memo` can also hint the receiver about what the passphrase is. To accept the cheque and get the fund in it, the receiver must provide correct passphrase, whose low 31 bytes of `keccak256` hash must be equal to the low 31 bytes of `passphraseOrHashtag`. The exact value of the highest byte is not taken into consideration.

A cheque can has a memo, which is always encrypted with the receiver's public key for encryption. If a receiver does not book her public key for encryption in the contract, the contract must refuse anyone to send cheques with non-zero-length memos to her.

The function `writeCheques` is a batched version of `writeCheque`. It can write several cheques to different receivers at one time. The `deadline` and the funds' `coinType` and `amount` for the cheques must be the same. The memos and passphrases (or hashtags) for different recievers, can be different.

For each sent cheque, the contract must assign a unique 256-bit ID to it, which will be used to refer to this cheque in the subsequent operations.

**5.1.1.5 revokeCheque**

```text
function revokeCheque(uint id) public;
function revokeCheques(uint[] calldata idList) external;
```

The sender who wrote a cheque can revoke it by calling `revokeCheque` with the cheque's `id`, after it is expired, i.e., passes its deadline. Thus she can take back the fund inside the cheque.

The function `revokeCheques` is a batched version of `revokeCheque`. It revokes multiple expired cheques at a time.

**5.1.1.6 acceptCheque**

```text
function acceptCheque(uint id, bytes calldata passphrase) external;
function acceptCheques(uint[] calldata idList) external;
```

The receiver can accept a cheque by providing a passphrase, before it is expired. If the cheque has a passphrase, then passphrase provided by the receiver will be hashed and checked against the `passphraseOrHashtag` field. If the passphrase is incorrent, the receiver cannot get the fund.

The function `acceptCheques` is a batched version of `acceptCheque`, which does not have a `passphrase` argument. All the specified cheques must have no passphrase.

**5.1.1.7 refuseCheque**

```text
function refuseCheque(uint id) external;
function refuseCheques(uint[] calldata idList) external;
```

The receiver can refuse a cheque anytime before it is expired. The fund inside the refused cheque will be immediately returned back to the sender.

The function `refuseCheques` is a batched version of `refuseCheque`.

#### 5.1.2 Events

**5.1.2.1 SetEncryptionPubkey**

```text
event SetEncryptionPubkey(address indexed payee, address referee, uint key);
```

* **MUST** trigger when a user sets her public key for encryption.

**5.1.2.2 UnsetEncryptionPubkey**

```text
event UnsetEncryptionPubkey(address indexed payee);
```

* **MUST** trigger when a user unsets her public key for encryption.

**5.1.2.3 NewCheque**

```text
event NewCheque(address indexed payee, uint indexed id, address indexed drawer,
		uint coinTypeAndAmount, uint startAndEndTime, uint passphraseOrHashtag, bytes memo);
```

* **MUST** trigger when a new cheque is successfully generated. `payee` is the account who can accept this cheque, `id` is assigned by the contract to uniquely identify this cheque, and `drawer` is the account who writes this cheque. The `passphraseOrHashtag` and `memo` have the same value as the arguments for calling `writeCheque`. The high 160 bits of `coinTypeAndAmount` is the fund's SEP20 address and the low 96 bits is the amount. The bits 127-64 of `startAndEndTime` is the time when this cheque is generated and bits 63-0 of `startAndEndTime` is the deadline.

**5.1.2.4 RevokeCheque**

```text
event RevokeCheque(address indexed payee, uint indexed id, address indexed drawer);
```
* **MUST** trigger when an expired cheque is revoked. `payee` is the account who did not accept this cheque, `id` was assigned by the contract to uniquely identify this cheque, and `drawer` is the account who wrote this cheque. 

**5.1.2.5 AcceptCheque**

```text
event AcceptCheque(address indexed payee, uint indexed id, address indexed drawer);
```

* **MUST** trigger when a cheque is accepted. `payee` is the account who accepts this cheque, `id` was assigned by the contract to uniquely identify this cheque, and `drawer` is the account who wrote this cheque. 

**5.1.2.6 RefuseCheque**

```text
event RefuseCheque(address indexed payee, uint indexed id, address indexed drawer);
```

* **MUST** trigger when a cheque is refused. `payee` is the account who refuses this cheque, `id` was assigned by the contract to uniquely identify this cheque, and `drawer` is the account who wrote this cheque. 

## 6. License

The content is licensed under [CC0](https://creativecommons.org/publicdomain/zero/1.0/).

