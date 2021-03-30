# SEP18: Rejectable token transfers on smartBCH

- [SEP-18: Rejectable token transfers on smartBCH](#rejectable-token-transfers-on-smartbch)
  - [1. Summary](#1--summary)
  - [2. Abstract](#2--abstract)
  - [3. Motivation](#3--motivation)
  - [4. Status](#4--status)
  - [5. Specification](#5--specification)
    - [5.1 Rejectable transfers](#51-rejectable-transfers)
      - [5.1.1 Methods](#511-methods)
        - [5.1.1.1 agentInfo](#5111-agentinfo)
        - [5.1.1.2 minimumAcceptableAmount](#5112-minimumacceptableamount)
        - [5.1.1.3 transfer](#5113-transfer)
        - [5.1.1.4 getPendingTransfer](#5114-getpendingtransfer)
        - [5.1.1.5 revoke](#5115-revoke)
        - [5.1.1.6 accept](#5116-accept)
        - [5.1.1.7 reject](#5117-reject)
      - [5.1.2 Events](#512-events)
        - [5.1.2.1 Transfer](#5121-transfer)
        - [5.1.2.2 Accept](#5122-accept)
        - [5.1.2.3 Reject](#5123-reject)
        - [5.1.2.4 Revoke](#5124-revoke)
  - [6. License](#6-license)

## 1.  Summary
This SEP proposes an interface standard to create token transfer agent contracts on smartBCH.

## 2.  Abstract
The following standard defines the implementation of APIs for token transfer agent smart contracts. This agent smart contract holds the tokens the sender transfers and the recipient can choose to accept them or return them back to the sender.

## 3.  Motivation
Many IM tools support the feature of "Red Envelop", with which the recipient can choose to accept or ignore. Normal token transferring can not provide such a feature, so a special agent constract is needed to support such a feature.

This SEP can work with custodial wallets, where the private key is not controlled by the recipient but the wallet operator. The recipient can use the preimage-checking mechanism to improve security.

## 4.  Status
This SEP is under draft.

## 5.  Specification

### 5.1 Rejectable transfers

**NOTES**:
- The following specifications use syntax from Solidity **0.6.12** (or above)
- All the listed functions and events MUST be implemented.

####  5.1.1 Methods

##### 5.1.1.1 agentInfo
```
function agentInfo() external view returns (address token, uint unit);
```

Each agent contract handles one SEP20 token and the transferred tokens must be integral multiple of a unit. `agentInfo()` returns the token's address and the unit amount.

##### 5.1.1.2 minimum acceptable amount
```
function setMinimumAcceptableAmount(uint amount) external;
function getMinimumAcceptableAmount(address account) external returns (uint);
```

A user can use `setMinimumAcceptableAmount` to set the minimum acceptable amount that others transfer to her. If she never sets such a value, its default value is zero. And `getMinimumAcceptableAmount` queries the minimum acceptable amount set by an `account`.

##### 5.1.1.3 transfer
```
function transfer(address to, uint packedArgs, bytes calldata message) external returns (bool);
```

This function transfers some tokens into this agent contract, pending for going to the `to` address in the future, with a `message` explaining why. The bit fields `packedArgs` contain extra arguments:

- 64-bit transferring amount (255~192)
- 31-bit deadline (191~161), which equals the deadline's UNIX timestamp divied by 3600
- 1-bit checkPreimage (160), specifying whether the recipient should enter a correct `preimage` to recieve the tokens
- 160-bit ticket (159~0), which is used to uniquely identify a transfer to some recipient. It contains two parts:
    - 32-bit nonce (159~128), which are meaningless bits, just used to avoid conflicting with existing ticket
    - 128-bit hash low bits (127~0), which are the low 128 bits of `keccak(preimage)`

This function returns true on success, returns false if the transferred amount is less than the recipient's minimum acceptable amount, and throws on other errors.

##### 5.1.1.4 getPendingTransfer
```
function getPendingTransfer(address to, uint160 ticket) external view returns (uint packedInfo);
```

Given a recipient's address `to` and a `ticket`, query a 256-bit word `packedInfo` which describes a pending transfer. The bit fields of `packedInfo` are:

- 64-bit transferring amount (255~192)
- 31-bit deadline (191~161), which equals the deadline's UNIX timestamp divied by 3600
- 1-bit checkPreimage (160), specifying whether the recipient should enter a correct `preimage` to recieve the tokens
- 160-bit from-address (159~0), showing who initiated this transfer by sending tokens into this agent contract

##### 5.1.1.5 revoke
```
function revoke(address to, uint160 ticket) external returns (bool);
```

The sender who initiated a transfer can revoke it by calling `revoke` with the recipient's address `to` and the `ticket`. A successful revocation must happen after the deadline. The sender could initiate the transfer by specifying a zero deadline, which means she can revoke it at any time.

This function returns true on success, returns false if current timestamp is no larger than deadline and throws on other errors.

##### 5.1.1.6 accept
```
function accept(uint160 ticket) external returns (bool);
function acceptWithPreimage(uint160 ticket, uint preimage) external returns (bool);
function acceptWithBeneficiary(uint160 ticket, address beneficiary) external returns (bool);
function acceptWithPreimageAndBeneficiary(uint160 ticket, uint preimage, address beneficiary) external returns (bool);
```

A recipient accepts the tokens in a pending transfer by specifying the `ticket` and the coins will be sent to `beneficiary`. If the `checkPreimage` bit of `packedInfo` of this pending transfer is 1, the recipient must also specify a correct `preimage` such that the low 128 bits of `keccak(preimage)` and `ticket` are the same.

There are four variants of functions which have different arguments. If `preimage` is not specified, its default value is zero. If `beneficiary` is not specified, its default value is the recipient's address.

These functions return true on success, return false if checking of `preimage` is failed, and throw on other errors.

A recipient can use an address from non-custodial wallet as the `beneficiary` address, such that the recipient's account will never accumulate a lot of coins. The sender can use other channels (IM, email, SMS, etc) to inform the recipient about the `presage`. Thus the custodial wallet's operator cannot accept all its customers pending transfers and dispear.

##### 5.1.1.7 reject
```
function reject(uint160 ticket) external;
```

A recipient rejects the tokens in a pending transfer by specifying the `ticket` and the coins will be returned to the initiator.

#### 5.1.2 Events

##### 5.1.2.1 Transfer
```
event Transfer(address indexed from, address indexed to, uint indexed packedArgs, bytes message);
```
- **MUST** trigger when a sender successfully initiates a pending transfer.

##### 5.1.2.2 Accept
```
event Accept(address indexed from, address indexed to, uint indexed packedArgs);
```
- **MUST** trigger when a recipient successfully accepts a pending transfer.

##### 5.1.2.3 Reject
```
event Reject(address indexed from, address indexed to, uint indexed packedArgs);
```
- **MUST** trigger when a recipient rejects a pending transfer.

##### 5.1.2.4 Revoke
```
event Revoke(address indexed from, address indexed to, uint indexed packedArgs);
```
- **MUST** trigger when a sender successfully revokes a pending transfer she initiated.

## 6. License

The content is licensed under [CC0](https://creativecommons.org/publicdomain/zero/1.0/).


