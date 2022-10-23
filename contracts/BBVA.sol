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
    uint256 public totalRewardsCount =0;
    event NFTStaked(address owner, uint256 tokenId, uint256 value);
    event NFTUnstaked(address owner, uint256 tokenId, uint256 value);
    event Claimed(address owner, uint256 amount);

    // reference to the Block NFT contract
    BBVANFTRewards nft;
    BBVAToken token;
    address private immutable i_owner;
    // maps
    mapping(uint256 => Reward) public allRewards;
    mapping(address => bool) public admins;

    constructor(BBVANFTRewards _nft, BBVAToken _token) {
        i_owner = msg.sender;
        nft = _nft;
        token = _token;
    }
    //for testing purposes we are not using this
    modifier onlyAdminOrOwner() {
        require(
            (admins[msg.sender] == true || msg.sender == i_owner),
            "Acount is not admin or owner"
        );
        _;
    }

    function addAdmin(address _admin) external  {
        admins[_admin] = true;
    }

    function getAdmin(address _address) external view returns (bool) {
        return admins[_address];
    }

    function addPointsToAcount(address _to, uint256 _amount)
        external
        
    {
        token.mint(_to, _amount);
    }

    function addReward(
        uint256 _expiration,
        uint256 _cost,
        string memory _metadata
    )
        public
         // uint48 _expirationTime,
    {
        totalRewardsCount += 1;
        uint256 newRewardId = totalRewardsCount;
        allRewards[newRewardId] = Reward({
            rewardId: newRewardId,
            expiration: uint48(_expiration),
            cost: _cost,
            metadata: _metadata
        });
    }

    function deleteReward(uint256 rewardId) external  {
        delete allRewards[rewardId];
        totalRewardsCount -= 1;
    }

    function returnAllRewards()
        external
        view
        returns (Reward[] memory rewards)
    {
        uint256 rewardId;
        uint256 resultIndex = 0;
        Reward[] memory result = new Reward[](totalRewardsCount);
        for (rewardId = 1; rewardId <= totalRewardsCount; rewardId++) {
            result[resultIndex] = allRewards[rewardId];
            resultIndex++;
        }
        return result;
    }

    function getRewardById(uint256 rewardId)
        external
        view
        returns (Reward memory reward)
    {
        return allRewards[rewardId];
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
