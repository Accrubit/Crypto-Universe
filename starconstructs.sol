pragma solidity ^0.4.19;

contract StarFormation {

    event NewStar(uint starId, string name, uint fusion);

    uint fusionDigits = 21;
    uint fusionModulus = 10 ** fusionDigits;

    struct Star {
        string name;
        uint fusion;
    }

    Star[] public stars;

    mapping (uint => address) public starToOwner;
    mapping (address => uint) ownerStarCount;

    function _createStar(string _name, uint _fusion) private {
        uint id = stars.push(Star(_name, _fusion)) - 1;
        starToOwner[id] = msg.sender;
        ownerStarCount[msg.sender]++;
        NewStar(id, _name, _fusion);
    }

    function _generateRandomFusion(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % fusionModulus;
    }

    function createRandomStar(string _name) public {
        require(ownerStarCount[msg.sender] == 0);
        uint randFusion = _generateRandomFusion(_name);
        _createStar(_name, randFusion);
    }

}
