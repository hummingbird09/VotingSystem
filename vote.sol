// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;
// making a voting contract
// 1. we want the ability to accept proposals and store them
// proposal: their name,number

//2. voters & voting ability
// keep track of voting
// check voters are authenticated to vote

//3 chairman
// authenticate and deploy contract.

contract Ballot {
    struct proposal {
        // struct is used to create our own data type
        bytes32 name; // name of each proposal
        uint voteCount; //number of accumulated votes
    }
    // voters : voted , access to vote,vote index

    struct voter {
        uint vote;
        bool voted;
        uint weight;
        uint voteIndex;
    }
    proposal[] public proposals;
    mapping(address => voter) public voters; // voters get address as a key and voter for value

    address public chairperson;

    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;

        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    //function authenticate voter
    function giveRightToVote(address Voter) public {
        require(msg.sender == chairperson, "Only the chairperson ca give vote");
        require(!voters[Voter].voted, "the voter has already voted");
        require(voters[Voter].weight == 0);

        voters[Voter].weight = 1;
    }
    //function for voting
    function vote(uint Proposal) public {
        voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted");
        sender.voted = true;
        sender.vote = Proposal;

        proposals[Proposal].voteCount =
            proposals[Proposal].voteCount +
            sender.weight;
    }
    // functions for showing results
    //1. function that shows the winning proposal by integer
    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }
    //2. function that shows winner by name
    function winningName() public view returns (bytes32 winningName_) {
        winningName_ = proposals[winningProposal()].name;
    }
}
