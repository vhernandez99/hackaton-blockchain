// SPDX-License-Identifier: MIT LICENSE
pragma solidity 0.8.17;

import "./BBVAToken.sol";
import "./BBVANFTRewards.sol";
import "hardhat/console.sol";
import "hardhat/console.sol";

contract BBVA is Ownable {
    struct Reward {
        uint256 rewardId;
        uint48 expiration;
        uint256 cost;
        string metadata;
    }
    uint256 public totalRewards  ;
    event NFTStaked(address owner, uint256 tokenId, uint256 value);
    event NFTUnstaked(address owner, uint256 tokenId, uint256 value);
    event Claimed(address owner, uint256 amount);

    // reference to the Block NFT contract
    BBVANFTRewards nft;
    BBVAToken token;

    // maps 
    mapping(uint256 => Reward) public allRewards;
    constructor(BBVANFTRewards _nft, BBVAToken _token) {
        nft = _nft;
        token = _token;
        addReward();
    }

    function addReward() public // uint48 _expirationTime,
    // string memory _name,
    // uint256 _cost
    {
        totalRewards += 1;
        uint256 newRewardId = totalRewards;
        allRewards[newRewardId] = Reward({
            rewardId: newRewardId,
            expiration: uint48(86400),
            cost: 1000000000000000000,
            metadata: "ipfs:///..."
        });
    }

    function deleteReward(uint256 rewardId) external {
        delete allRewards[rewardId];
    }
    //requires caller to approve _amount in erc20 token
    function buyReward(
        address account,
        uint256 rewardId,
        uint256 _amount
    ) external {
        Reward memory reward = allRewards[rewardId];
        require(_amount >= reward.cost, "not enough sent");
        uint256 erc20balance = token.balanceOf(account);
        require(erc20balance >= reward.cost, "not enough balance");
        token.transferFrom(msg.sender, address(this), _amount);
        nft.mint(msg.sender, 1, reward.metadata);
    }
}
