// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "./interfaces/IRejectableTransferAgent.sol";
import "./interfaces/ISEP20.sol";

contract RejectableTransferAgent is IRejectableTransferAgent {
    address private owner;
    uint private tokenAndUnit;
    mapping(address => mapping(uint160 => uint)) private pendingInfo;
    mapping(address => uint) private minimumAcceptableAmount;

    function getOwner() external view returns (address) {
        return owner;
    }

    function changeUnit(uint96 unit) external {
        require(msg.sender == owner);
        tokenAndUnit = ((tokenAndUnit>>96)<<96)|uint(unit);
    }

    function _safeTransferFrom(address token, address from, address to, uint value) internal {
        uint beforeAmount = ISEP20(token).balanceOf(to);
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)'))) == 0x23b872dd;
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "TransferFailed");
        uint afterAmount = ISEP20(token).balanceOf(to);
        require(afterAmount == beforeAmount + value, "TransferValueMismatch");
    }

    function agentInfo() public override view returns (address token, uint unit) {
        uint tmp = tokenAndUnit;
        unit = uint(uint96(tmp));
        token = address(tmp>>96);
    }

    function setMinimumAcceptableAmount(uint amount) external override {
        minimumAcceptableAmount[msg.sender] = amount;
    }

    function getMinimumAcceptableAmount(address addr) external override returns (uint) {
        return minimumAcceptableAmount[addr];
    }

    //packedArgs:  uint64 amount(255~192), uint32 deadline(191~161), bool checkPreimage(160), uint160 ticket(159~0)
    //packedInfo:  uint64 amount(255~192), uint32 deadline(191~161), bool checkPreimage(160), address from(159~0)

    function transfer(address to, uint packedArgs, bytes calldata message) external override returns (bool) {
        uint packedInfo = ((packedArgs>>160)<<160)|uint(msg.sender);
        (address token, uint unit) = agentInfo();
        uint160 ticket = uint160(packedArgs);
        packedArgs >>= (160+32);
        uint amount = packedArgs * unit;
        if(amount < minimumAcceptableAmount[to]) {
            return false;
        }
        _safeTransferFrom(token, msg.sender, address(this), amount);
        pendingInfo[to][ticket] = packedInfo;
        emit Transfer(msg.sender, to, packedArgs, message);
        return true;
    }

    function getPendingTransfer(address to, uint160 ticket) external override view returns (uint packedInfo) {
        return pendingInfo[to][ticket];
    }

    function revoke(address to, uint160 ticket) external override returns (bool) {
        (address token, uint unit) = agentInfo();
        uint packedInfo = pendingInfo[to][ticket];
        require(packedInfo != 0, "PendingTransferNotFound");
        uint packedArgs = ((packedInfo>>160)<<160)|uint(ticket);
        address from = address(packedInfo);
        require(from == msg.sender, "NotSender");
        packedInfo >>= 161;
        uint deadline = 3600*(packedInfo & ((1<<31)-1));
        if(block.timestamp <= deadline) {
            return false;
        }
        packedInfo >>= 31;
        uint amount = packedInfo * unit;
        delete pendingInfo[to][ticket];
        ISEP20(token).transfer(from, amount);
        emit Revoke(from, to, packedArgs);
        return true;
    }

    function accept(uint160 ticket) external override returns (bool) {
        return acceptWithPreimageAndBeneficiary(ticket, 0, msg.sender);
    }

    function acceptWithPreimage(uint160 ticket, uint preimage) external override returns (bool) {
        return acceptWithPreimageAndBeneficiary(ticket, preimage, msg.sender);
    }

    function acceptWithBeneficiary(uint160 ticket, address beneficiary) external override returns (bool) {
        return acceptWithPreimageAndBeneficiary(ticket, 0, beneficiary);
    }

    function acceptWithPreimageAndBeneficiary(uint160 ticket, uint preimage, address beneficiary) public override returns (bool) {
        (address token, uint unit) = agentInfo();
        uint packedInfo = pendingInfo[msg.sender][ticket];
        require(packedInfo != 0, "PendingTransferNotFound");
        uint packedArgs = ((packedInfo>>160)<<160)|uint(ticket);
        address from = address(packedInfo);
        packedInfo >>= 160;
        bool checkPreimage = (packedArgs & 1) != 0;
        if(checkPreimage) {
            //only check low 128 bits
            if((uint(keccak256(abi.encodePacked(preimage)))<<128) != (uint(ticket)<<128)) {
                return false;
            }
        }
        packedInfo >>= 32;
        uint amount = packedInfo * unit;
        delete pendingInfo[msg.sender][ticket];
        ISEP20(token).transfer(beneficiary, amount);
        emit Accept(from, msg.sender, packedArgs);
        return true;
    }

    function reject(uint160 ticket) external override {
        (address token, uint unit) = agentInfo();
        uint packedInfo = pendingInfo[msg.sender][ticket];
        require(packedInfo != 0, "PendingTransferNotFound");
        uint packedArgs = ((packedInfo>>160)<<160)|uint(ticket);
        address from = address(packedInfo);
        packedInfo >>= (160+32);
        uint amount = packedInfo * unit;
        delete pendingInfo[msg.sender][ticket];
        ISEP20(token).transfer(from, amount);
        emit Reject(from, msg.sender, packedArgs);
    }
}

contract RejectableTransferProxy {
    address private owner;
    uint private tokenAndUnit;
    address internal immutable implLogic;

    constructor(uint _tokenAndUnit, address _logic, address _owner) public {
        tokenAndUnit = _tokenAndUnit;
        implLogic = _logic;
        owner = _owner;
    }

    // solhint-disable-next-line no-complex-fallback
    fallback() payable external {
        // solhint-disable-next-line no-inline-assembly
        address _impl = implLogic;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}

contract RejectableTransferAgentFactory {
    mapping(address => address) private tokenToAgent;
    address private admin;
    address private implLogic;
    event AgentCreated(address indexed agentAddress, uint tokenAndUnit);

    constructor(address _admin, address _implLogic) public {
        admin = _admin;
        implLogic = _implLogic;
    }

    function status() external view returns (address, address) {
        return (admin, implLogic);
    }

    function changeAdmin(address newAdmin) external {
        require(admin == msg.sender);
        admin = newAdmin;
    }

    function changeLogic(address newLogic) external {
        require(admin == msg.sender);
        implLogic = newLogic;
    }

    function getAgent(address tokenAddr) external view returns (address) {
        return tokenToAgent[tokenAddr];
    }

    function createAgent(uint tokenAndUnit) external returns (address) {
        address tokenAddr = address(tokenAndUnit>>96);
        require(tokenToAgent[tokenAddr] == address(0), "AlreadyCreated");
        bytes32 salt = bytes32(tokenAndUnit);
        RejectableTransferProxy proxy = new RejectableTransferProxy{salt: salt}(tokenAndUnit, implLogic, admin);
        tokenToAgent[tokenAddr] == address(proxy);
        emit AgentCreated(address(proxy), tokenAndUnit);
        return address(proxy);
    }
}


