pragma solidity ^0.5.5;


import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts

contract PupperCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {
    
    string name;
    string symbol;
    uint _cap;
    uint _goal;

       
    // @TODO: Pass the constructor parameters to the crowdsale contracts
    constructor (uint rate, address payable wallet, PupperCoin token, uint _openingTime, uint _closingTime)
        Crowdsale (1, wallet, token)
        CappedCrowdsale(_cap = 300 ether)
        TimedCrowdsale(_openingTime = _openingTime, _closingTime = _closingTime)
        RefundableCrowdsale(_goal = 300 ether)
        MintedCrowdsale() public
    {
    }
    
}

contract PupperCoinCrowdSaleDeployer {
   
    address public crowdsale_address;
    address payable public deployer;

    PupperCoin public token;
    address public token_address;
    uint _openingTime;
    uint _closingTime;
    uint fakenow;   


    function fastForward() public {
        fakenow += 100 weeks;
    }
  
    constructor(
            // @TODO: Fill in the constructor parameters!
            string memory name,
            string memory symbol,
            address payable wallet
        ) public
        
    {
            token = new PupperCoin(name, symbol, 0);
            token_address = address(token);
            deployer = wallet;
    }
    
    function isOpen() public view returns (bool) {
    return (fakenow > _openingTime);

    }

    function hasClosed() public view returns (bool) {
    return (fakenow < _closingTime);

    }

    function testAlreadyClosed() public {
    fastForward();
            
            
            init();         
    }
    
    function init() public {
        fakenow = now;
        PupperCoinCrowdsale crowdsale = new PupperCoinCrowdsale(1, deployer, token, fakenow, fakenow + 5 minutes);
        crowdsale_address = address(crowdsale);

        token.addMinter(crowdsale_address);
        token.renounceMinter();
    }
         
}