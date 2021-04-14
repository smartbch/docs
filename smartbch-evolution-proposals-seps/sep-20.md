# SEP20: Tokens on smartBCH

* [SEP-20: Tokens on smartBCH](sep-20.md#sep20-tokens-on-smartbch)
  * [1. Summary](sep-20.md#1--summary)
  * [2. Abstract](sep-20.md#2--abstract)
  * [3. Motivation](sep-20.md#3--motivation)
  * [4. Status](sep-20.md#4--status)
  * [5. Specification](sep-20.md#5--specification)
    * [5.1 Token](sep-20.md#51-token)
      * [5.1.1 Methods](sep-20.md#511-methods)
        * [5.1.1.1 name](sep-20.md#5111-name)
        * [5.1.1.2 symbol](sep-20.md#5112-symbol)
        * [5.1.1.3 decimals](sep-20.md#5113-decimals)
        * [5.1.1.4 totalSupply](sep-20.md#5114-totalsupply)
        * [5.1.1.5 balanceOf](sep-20.md#5115-balanceof)
        * [5.1.1.6 owner](sep-20.md#5116-owner)
        * [5.1.1.7 transfer](sep-20.md#5117-transfer)
        * [5.1.1.8 transferFrom](sep-20.md#5118-transferfrom)
        * [5.1.1.9 approve](sep-20.md#5119-approve)
        * [5.1.1.10 allowance](sep-20.md#51110-allowance)
        * [5.1.1.11 increaseAllowance](sep-20.md#51111-increaseAllowance)
        * [5.1.1.12 decreaseAllowance](sep-20.md#51112-decreaseAllowance)
      * [5.1.2 Events](sep-20.md#512-events)
        * [5.1.2.1 Transfer](sep-20.md#5121-transfer)
        * [5.1.2.2 Approval](sep-20.md#5122-approval)
  * [6. License](sep-20.md#6-license)

## 1.  Summary

This SEP proposes an interface standard to create token contracts on smartBCH.

## 2.  Abstract

The following standard defines the implementation of APIs for token smart contracts. It is proposed by deriving the ERC20 protocol of Ethereum and provides the basic functionality to transfer tokens, allow tokens to be approved so they can be spent by another on-chain third party.

## 3.  Motivation

A standard interface allows any tokens on smartBCH to be used by other applications: from wallets to decentralized exchanges in a consistent way. Besides, this standard interface also extends [ERC20](https://eips.ethereum.org/EIPS/eip-20) to facilitate cross chain transfer.

## 4.  Status

This SEP is under draft.

## 5.  Specification

### 5.1 Token

**NOTES**:

* The following specifications use syntax from Solidity **0.5.16** \(or above\)
* Callers MUST handle false from returns \(bool success\). Callers MUST NOT assume that false is never returned!

#### 5.1.1 Methods

**5.1.1.1 name**

```text
function name() external view returns (string)
```

* Returns the name of the token - e.g. "MyToken".
* **OPTIONAL** - This method can be used to improve usability, but interfaces and other contracts MUST NOT expect these values to be present.

**5.1.1.2 symbol**

```text
function symbol() external view returns (string)
```

* Returns the symbol of the token. E.g. “HIX”.
* This method can be used to improve usability
* **NOTE** - This method is optional in EIP20. In SEP20, this is a required method.

**5.1.1.3 decimals**

```text
function decimals() external view returns (uint8)
```

* Returns the number of decimals the token uses - e.g. 8, means to divide the token amount by 100000000 to get its user representation.
* This method can be used to improve usability
* **NOTE** - This method is optional in EIP20. In SEP20, this is a required method.

**5.1.1.4 totalSupply**

```text
function totalSupply() external view returns (uint256)
```

* Returns the total token supply.

**5.1.1.5 balanceOf**

```text
function balanceOf(address _owner) external view returns (uint256 balance)
```

* Returns the account balance of another account with address `_owner`.

**5.1.1.6 owner**

```text
function owner() external view returns (address);
```

* Returns the sep20 token owner which is necessary for binding with sep20 token.
* **OPTIONAL** - This method can be used to improve usability, but interfaces and other contracts MUST NOT expect these values to be present.

**5.1.1.7 transfer**

```text
function transfer(address _to, uint256 _value) external returns (bool success)
```

* Transfers `_value` amount of tokens to address `_to`, and MUST fire the Transfer event. The function SHOULD throw if the message caller’s account balance does not have enough tokens to spend.
* **NOTE** - Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
* **NOTE** - If there are some permission-control mechanism in the smart contract \(such as blacklist\), transfers of 0 values MUST be treated as normal transfers and undergo the same permission checks.

**5.1.1.8 transferFrom**

```text
function transferFrom(address _from, address _to, uint256 _value) external returns (bool success)
```

* Transfers `_value` amount of tokens from address `_from` to address `_to`, and MUST fire the Transfer event.
* The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf. This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in sub-currencies. The function SHOULD throw unless the `_from` account has deliberately authorized the sender of the message via some mechanism.
* **NOTE** - Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.

**5.1.1.9 approve**

```text
function approve(address _spender, uint256 _value) external returns (bool success)
```

* Allows `_spender` to withdraw from your account multiple times, up to the `_value` amount. If this function is called again it overwrites the current allowance with `_value`.
* **NOTE** - To prevent attack vectors like the one described here and discussed here, clients SHOULD make sure to create user interfaces in such a way that they set the allowance first to 0 before setting it to another value for the same spender. THOUGH The contract itself shouldn’t enforce it, to allow backwards compatibility with contracts deployed before

**5.1.1.10 allowance**

```text
  function allowance(address _owner, address _spender) external view returns (uint256 remaining)
```

* Returns the amount which `_spender` is still allowed to withdraw from `_owner`.

**5.1.1.11 increaseAllowance**

```text
  function increaseAllowance(address _spender, uint256 _delta) external returns (bool success)
```

* Increases the amount which `_spender` is still allowed to withdraw from you.
* **OPTIONAL** - This method can be used to prevent attack vectors, but interfaces and other contracts MUST NOT expect these values to be present.

**5.1.1.12 decreaseAllowance**

```text
    function decreaseAllowance(address _spender, uint256 _delta) external returns (bool success)
```

* Decreases the amount which `_spender` is still allowed to withdraw from you.
* **OPTIONAL** - This method can be used to prevent attack vectors, but interfaces and other contracts MUST NOT expect these values to be present.

#### 5.1.2 Events

**5.1.2.1 Transfer**

```text
event Transfer(address indexed _from, address indexed _to, uint256 _value)
```

* **MUST** trigger when tokens are transferred, including zero value transfers.
* A token contract which creates new tokens SHOULD trigger a Transfer event with the `_from` address set to 0x0 when tokens are created.

**5.1.2.2 Approval**

```text
event Approval(address indexed _owner, address indexed _spender, uint256 _value)
```

**MUST** trigger on any successful call to `approve(address _spender, uint256 _value)`, `increaseAllowance(address _spender, uint256 _delta)` or `decreaseAllowance(address _spender, uint256 _delta)`.

## 6. License

The content is licensed under [CC0](https://creativecommons.org/publicdomain/zero/1.0/).

