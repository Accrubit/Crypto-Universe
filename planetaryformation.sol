pragma solidity ^0.4.23;

import "./ownable.sol";

contract PlanetFormation is Ownable {

    event NewPlanet(uint planetId, string name, uint terra);

    uint terraDigits = 24;
    uint terraModulus = 10 ** terraDigits;
    uint cooldownTime = 7 days;

    struct Planet {
      string name;
      uint terra;
      uint32 population;
      uint32 readyTime;
    }

    Planet[] public planets;

    mapping (uint => address) public planetToOwner;
    mapping (address => uint) ownerPlanetCount;

    function _createPlanet(string _name, uint _terra) internal {
        uint id = planets.push(Planet(_name, _terra, 0, uint32(now + cooldownTime))) - 1;
        planetToOwner[id] = msg.sender;
        ownerPlanetCount[msg.sender]++;
        NewPlanet(id, _name, _terra);
    }

    function _generateRandomTerra(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % terraModulus;
    }

    function createRandomPlanet(string _name) public {
        require(ownerPlanetCount[msg.sender] == 0);
        uint randTerra = _generateRandomTerra(_name);
        randTerra = randTerra - randTerra % 100;
        _createPlanet(_name, randTerra);
    }

}
