//Sample contract
contract Sample
{
	uint value;
	function Sample(uint v) {
		value = v;
	}
	function set(uint v) {
		value = v;
	}
	function get() constant returns (uint) {
		return value;
	}
}

contract Rating {
	
	struct UserRating
    {
        address userId;   // short name (up to 32 bytes)
        uint rating; // number of accumulated votes
    }
	
	mapping (bytes32 => UserRating[]) public userRatings;
	mapping (bytes32 => uint) public avgRatings;

	
	function setRating(bytes32 _moviekey, uint256 _value) {
		userRatings[_moviekey].push(UserRating({
			userId: msg.sender,
			rating: _value
		}));
		avgRatings[_moviekey] = averageRating(_moviekey);
	}
	
	function averageRating(bytes32 _moviekey) returns (uint average) {
		uint total = 0;
		for(uint i = 0; i < userRatings[_moviekey].length; i++){
			total += userRatings[_moviekey][i].rating;
		}
		return total;
	}
}

contract ratingAverage {
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Voter {
        bool voted;  // if true, that person already voted
        uint vote;   // index of the voted proposal
    }

    // This is a type for a single proposal.
    struct Proposal
    {
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Proposal` structs.
    Proposal[] public proposals;

    /// Create a new ballot to choose one of `proposalNames`.
    function Ballot(bytes32[] proposalNames) {
        // For each of the provided proposal names,
        // create a new proposal object and add it
        // to the end of the array.
        for (uint i = 0; i < proposalNames.length; i++) {
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposal.push(...)`
            // appends it to the end of `proposals`.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // Give `voter` the right to vote on this ballot.
    // May only be called by `chairperson`.
    function giveRightToVote(address voter) {
        if (voters[voter].voted) {
            // `throw` terminates and reverts all changes to
            // the state and to Ether balances. It is often
            // a good idea to use this if functions are
            // called incorrectly. But watch out, this
            // will also consume all provided gas.
            throw;
        }
    }


    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint proposal) {
        Voter sender = voters[msg.sender];
        if (sender.voted)
            throw;
        sender.voted = true;
        sender.vote = proposal;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += 1;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() constant
            returns (uint winningProposal)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal = p;
            }
        }
    }
}