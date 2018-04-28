pragma solidity ^0.4.19;

contract StarFormation {

    event NewStar(uint starId, string name, uint fusion);

    uint fusionDigits = 21;
    uint fusionModulus = 10 ** dnaDigits;

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

contract PlanetFormation {

    event NewPlanet(uint planetId, string name, uint terra);

    uint terraDigits = 24;
    uint terraModulus = 10 ** terraDigits;

    struct Planet {
        string name;
        uint terra;
    }

    Planet[] public planets;

    mapping (uint => address) public planetToOwner;
    mapping (address => uint) ownerPlanetCount;

    function _createPlanet(string _name, uint _terra) private {
        uint id = planets.push(Star(_name, _terra)) - 1;
        planetToOwner[id] = msg.sender;
        ownerPlanetCount[msg.sender]++;
        NewPlanet(id, _name, _terra);
    }

    function _generateRandomTerra(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % terraModulus;
    }

    function createRandomPlanet(string _name) public {
        require(ownerPlanetCount[msg.sender] <= 8);
        require(ownerStarCount[msg.sender] >= 1);
        uint randTerra = _generateRandomTerra(_name);
        _createPlanet(_name, randTerra);
    }

}
