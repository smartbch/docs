// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IRejectableTransferAgent {
    event Transfer(address indexed from, address indexed to, uint indexed packedArgs, bytes message);
    event Accept(address indexed from, address indexed to, uint indexed packedArgs);
    event Reject(address indexed from, address indexed to, uint indexed packedArgs);
    event Revoke(address indexed from, address indexed to, uint indexed packedArgs);

    function agentInfo() external view returns (address token, uint unit);
    function setMinimumAcceptableAmount(uint amount) external;
    function getMinimumAcceptableAmount(address addr) external returns (uint);
    function transfer(address to, uint packedArgs, bytes calldata message) external returns (bool);
    function getPendingTransfer(address to, uint160 ticket) external view returns (uint packedInfo);
    function revoke(address to, uint160 ticket) external returns (bool);
    function accept(uint160 ticket) external returns (bool);
    function acceptWithPreimage(uint160 ticket, uint preimage) external returns (bool);
    function acceptWithBeneficiary(uint160 ticket, address beneficiary) external returns (bool);
    function acceptWithPreimageAndBeneficiary(uint160 ticket, uint preimage, address beneficiary) external returns (bool);
    function reject(uint160 ticket) external;
}


