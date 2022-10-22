// SPDX-License-Identifier: MIT LICENSE
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

pragma solidity 0.8.17;

contract BBVANFTRewards is ERC721Enumerable, Ownable {
    using Strings for uint256;
    string public baseURI;
    string public baseExtension = ".json";
    bool public paused = false;
    struct Token {
        uint24 tokenId;
        string metadata;
        bool rewardUsed;
    }
    mapping(uint256 => Token) public vault;

    constructor() ERC721("BBVA Rewards", "BBVARWRDS") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://QmYB5uWZqfunBq7yWnamTqoXWBAHiQoirNLmuxMzDThHhi/";
    }

    function mint(
        address _to,
        uint256 _mintAmount,
        string memory _metadata
    ) public payable {
        uint256 supply = totalSupply();
        require(!paused);
        require(_mintAmount > 0);
        vault[supply + 1] = Token({
            tokenId: uint24(supply + 1),
            metadata: _metadata,
            rewardUsed: false
        });
        _safeMint(_to, supply + 1);
    }
    function redeemReward(uint256 _tokenId) external {
        Token memory token = vault[_tokenId];
        address owner = ownerOf(_tokenId);
        require(
            token.rewardUsed == false,
            "Reward already redeemed for this token"
        );
        require(owner == msg.sender, "You are not the owner of this reward");
        vault[_tokenId].rewardUsed = true;
    }
    
    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        Token memory token = vault[_tokenId];
        return token.metadata;
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function withdraw() public payable onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }
}
