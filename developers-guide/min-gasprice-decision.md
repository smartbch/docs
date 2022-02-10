### Decision on minimum gas price

The chain-wide minimum gas price is a consensus parameter, which is the lower bound of the minimum gas prices set by different validators. This consensus parameter is modified by the validators.

After the XHedge upgrade, validators (or their corresponding `rewardTo` account) can send transactions to the staking contract (address:  0x2710) to anticipant the decision of minimum gas price.

The staking contract is a system contract implemented natively using golang, instead of solidity. However, we provide a pseudo-code at the end of this document to show how the logic of gas price decisions, hoping it can help your understanding.

#### The logic of gas price decisions 

There are two hard-coded constants: the upper bound and lower bound of the minimum gas price. The decided minimum gas price cannot exceed these bounds.

The minimum gas price is decided in a voting process:

1. A validator starts a voting process by calling `proposal`. This function's argument is the target minimum gas price this validator votes for.
2. The other validators call `vote` to specify the target minimum gas price of each one.
3. The voting process will last for 24 hours. When it ends, anyone can call `executeProposal` to make the decision effective. 

The decided minimum gas price is the middle of the arithmetic mean value and the geometric mean value of all the voted targets.

#### Psuedo code

```solidity

contract MinGasPriceVote {
	uint constant MinGasPriceDeltaRate = 5;
	uint constant MinGasPriceUpperBound = 500000000000; //500gwei
	uint constant MinGasPriceLowerBound = 10000000;   //0.01gwei
	uint constant DefaultProposalDuration = 60 * 60 * 24;    //24hour

	uint minGasPrice public;
	uint endVotingTime public;
	address[] voters public;
	mapping(address => uint) voteMap public;

	function proposal(uint target) external {
		require(isValidator(msg.sender), "not-a-validator");
		uint64 votingPower = getVotingPower(msg.sender);
		require(votingPower != 0, "inactive-validator");
		require(endVotingTime == 0, "is-still-voting");
		checkTarget(minGasPrice, target);
		endVotingTime = block.timestamp + DefaultProposalDuration;
		voteMap[msg.sender] = (target<<64) + uint(votingPower);
		addVoter(msg.sender);
	}

	function checkTarget(uint lastMinGasPrice, uint target) private {
		require(MinGasPriceLowerBound < target, "target-too-small");
		require(target < MinGasPriceUpperBound, "target-too-large");
		if(lastMinGasPrice != 0) {
			require(lastMinGasPrice/MinGasPriceDeltaRate <= target &&
				target <= lastMinGasPrice*MinGasPriceDeltaRate, "target-outof-range");
		}
	}

	function addVoter(address voter) private {
		for(uint i=0; i<voters.length; i++) {
			if(voters[i] == voter) return;
		}
		voters.push(voter);
	}

	function vote(uint target) external {
		require(isValidator(msg.sender), "not-a-validator");
		uint64 votingPower = getVotingPower(msg.sender);
		require(votingPower != 0, "inactive-validator");
		require(endVotingTime != 0, "not-in-voting");
		require(block.timestamp < endVotingTime, "voting-finished");
		if(target == 0) {
			target = minGasPrice;
		} else {
			checkTarget(minGasPrice, target);
		}
		voteMap[msg.sender] = (target<<64) + uint(votingPower);
		addVoter(msg.sender);
	}

	function executeProposal() external {
		require(endVotingTime != 0, "not-in-voting");
		require(endVotingTime < block.timestamp, "voting-not-finished");
		minGasPrice = calculateMinGasPrice();
		endVotingTime = 0;
		uint index = voters.length-1;
		do {
			address voter = voters[index];
			delete voteMap[voter];
			voters.pop();
			index--;
		} while(index!=0);
	}

	function calculateMinGasPrice() private returns (uint) {
		uint sumPower = 0;
		uint sumTargets = 0;
		uint[] memory targets = new uint[](voters.length);
		for(uint i=0; i<voters.length; i++) {
			address voter = voters[i];
			uint vote = voteMap[voter];
			(uint target, uint votingPower) = (uint(vote>>64), uint(uint64(vote)));
			sumPower += votingPower;
			sumTargets += target*votingPower;
			targets[i] = target;
		}
		uint t1 = calculateMeidan(targets);
		uint t2 = sumTargets / sumPower;
		return (t1+t2)/2;
	}

	function calculateMeidan(uint[] memory targets) private pure returns (uint) {
		uint index = targets.length/2; 4/2=2
		if(index*2 == targets.length) {
			returns (targets[index-1] + targets[index]) / 2
		}
		return targets[index];
	}

	function sort(uint[] memory arr) private pure {
	    if (arr.length > 0)
	        quickSort(arr, 0, arr.length - 1);
	}
	
	function quickSort(uint[] memory arr, uint left, uint right) private pure {
	    if (left >= right)
	        return;
	    uint p = arr[(left + right) / 2];   // p = the pivot element
	    uint i = left;
	    uint j = right;
	    while (i < j) {
	        while (arr[i] < p) ++i;
	        while (arr[j] > p) --j;         // arr[j] > p means p still to the left, so j > 0
	        if (arr[i] > arr[j])
	            (arr[i], arr[j]) = (arr[j], arr[i]);
	        else
	            ++i;
	    }
	
	    // Note --j was only done when a[j] > p.  So we know: a[j] == p, a[<j] <= p, a[>j] > p
	    if (j > left)
	        quickSort(arr, left, j - 1);    // j > left, so j > 0
	    quickSort(arr, j + 1, right);
	}
}
```



