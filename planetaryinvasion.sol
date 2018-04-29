pragma solidity ^0.4.23;

import "./planetconstructs.sol";

contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract PlanetInvasion is PlanetFormation {

  KittyInterface kittyContract;

  function setKittyContractAddress(address _address) external onlyOwner {
    kittyContract = KittyInterface(_address);
  }

  function _triggerCooldown(Planet storage _planet) internal {
    _planet.readyTime = uint32(now + cooldownTime);
  }

  function _isReady(Planet storage _planet) internal view returns (bool) {
      return (_planet.readyTime <= now);
  }

  function invadeAndMultiply(uint _planetId, uint _targetDna, string _classification) internal {
    require(msg.sender == planetToOwner[_planetId]);
    Planet storage myPlanet = planets[_planetId];
    require(_isReady(myPlanet));
    _targetDna = _targetDna % terraModulus;
    uint newTerra = (myPlanet.terra + _targetDna) / 2;
    if (keccak256(_classification) == keccak256("kitty")) {
      newDna = newDna - newDna % 100 + 99;
    }
    _createPlanet("NoName", newTerra);
    _triggerCooldown(myPlanet);
  }

  function populateWithKitty(uint _planetId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    invadeAndMultiply(_planetId, kittyDna, "kitty");
  }

}
