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
    uint256 public totalRewards;
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

    modifier onlyAdminOrOwner() {
        require(
            (admins[msg.sender] == true || msg.sender == i_owner),
            "Acount is not admin or owner"
        );
        _;
    }

    function addAdmin(address _admin) external {
        admins[_admin] = true;
    }

    function addPointsToAcount(address _to, uint256 _amount)
        external
        onlyAdminOrOwner
    {
        token.mint(_to, _amount);
    }

    function addReward(
        uint256 _expiration,
        uint256 _cost,
        string memory _metadata
    )
        public
        onlyAdminOrOwner // uint48 _expirationTime,
    {
        totalRewards += 1;
        uint256 newRewardId = totalRewards;
        allRewards[newRewardId] = Reward({
            rewardId: newRewardId,
            expiration: uint48(_expiration),
            cost: _cost,
            metadata: _metadata
        });
    }
    function deleteReward(uint256 rewardId) external onlyAdminOrOwner {
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
