pragma solidity ^0.5.16;

contract Voting {
    
    //owner details
    address public contract_owner;
    
    //public info
    uint256 public total_voters;
    uint256 public total_candidates;
    
    address public winner_candidate;
    
    //candidate dynamic array
    Candidate[] public candidates;
    
    //voter dynamic array
    Voter[] public voters;
    
    uint256 total_votes_casted;
    
    mapping(address => Voter) public address_to_voter;
    mapping(address => Candidate) public address_to_candidate;
    
    struct Candidate{
        address candidate_address;
        uint256 votes;
        string name;
    }
    
    struct Voter{
        string name;
        address voter_address;
        bool has_voted;
    }
    
    constructor() public {
        contract_owner = msg.sender;
    }
    
    function addCandidate(string memory _name) public {
        uint256 i;
        bool ispresent = false;
        while(i < total_candidates){
            if(keccak256(abi.encodePacked(candidates[i].name)) == keccak256(abi.encodePacked(_name)) && candidates[i].candidate_address == msg.sender){
                ispresent = true;
            }
        }
        
        require(ispresent == false);
        
        //add candidate object
        Candidate memory candidate;
        candidate.candidate_address = msg.sender;
        candidate.votes = 0;
        candidate.name = _name;
        
        //adding to mapping
        address_to_candidate[msg.sender] = candidate;
        
        //adding to dynamic array
        candidates.push(candidate);
        
        total_candidates++;
    }
    
    function addVoter(string memory _name) public {
        uint256 i;
        bool ispresent = false;
        while(i < total_voters){
            if(keccak256(abi.encodePacked(voters[i].name)) == keccak256(abi.encodePacked(_name)) && voters[i].voter_address == msg.sender){
                ispresent = true;
            }
        }
        
        require(ispresent == false);
        
        //add voter object
        Voter memory voter;
        voter.name = _name;
        voter.voter_address = msg.sender;
        voter.has_voted = false;
        
        //adding to mapping
        address_to_voter[msg.sender] = voter;
        
        //adding to dynamic array
        voters.push(voter);
        
        total_voters++;
        
    }
    
    function vote(address _candidate_address) public {
        //check if the candidate exists
        uint256 j;
        bool iscandidatepresent = false;
        while(j < total_candidates){
            if(candidates[j].candidate_address == _candidate_address){
                iscandidatepresent = true;
            }
        }
        
        require(iscandidatepresent == true);

        //check if a voter
        uint256 i;
        bool isvoterpresent = false;
        while(i < total_voters){
            if(voters[i].voter_address == msg.sender){
                isvoterpresent = true;
            }
        }
        
        require(isvoterpresent == true);
       
        //check if already voter_address
        require(address_to_voter[msg.sender].has_voted == false);
        
        //vote candidate
        Candidate memory candidate;
        candidate = address_to_candidate[_candidate_address];
        candidate.votes++;
        //setting new candidate data
        address_to_candidate[_candidate_address] = candidate;
        
        //has_voted to true
        Voter memory voter;
        voter.has_voted = true;
        //setting new voter data
        address_to_voter[msg.sender] = voter;
        
        declareWinner();
        
    }
    
    function declareWinner() private {
        uint256 i;
        uint256 max_votes;
        address winner;
        while(i < total_candidates){
            if(candidates[i].votes > max_votes){
                winner = candidates[i].candidate_address;
            }
        }
        
        winner_candidate = winner;
    }
    
}
