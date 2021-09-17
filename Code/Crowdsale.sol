pragma solidity ^0.5.0;

import "./LocalCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract LocalCoinSale is Crowdsale, 
    MintedCrowdsale,
    CappedCrowdsale,
    TimedCrowdsale,
    RefundablePostDeliveryCrowdsale {

    constructor(
        uint rate,
        address payable wallet,
        LocalCoin token,
        uint cap,
        uint openingTime,
        uint closingTime,
        uint goal
        
    )
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
        
        public
    {
        // constructor can stay empty
    }
}

contract LocalCoinSaleDeployer {

    address public local_sale_address;
    address public token_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet
    )
        public
    {
		LocalCoin token = new LocalCoin(name, symbol, 0);
		token_address = address(token);
		
        LocalCoinSale Local_sale = new LocalCoinSale(1, wallet, token, 300e18, now, (now + 24 weeks), 300e18);
        local_sale_address = address(Local_sale);

        token.addMinter(local_sale_address);
        token.renounceMinter();
    }
}

// https://ropsten.etherscan.io/address/0xbcbb960f7428b6fd3cd07ff26561f37d82339f11
