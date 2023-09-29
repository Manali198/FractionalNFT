// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFT is Ownable, ERC721URIStorage {
    using SafeMath for uint256;

    // Event emitted when revenue is distributed
    event RevenueDistributed(
        uint256 indexed tokenId,
        uint256 amount,
        uint256 timestamp
    );

    // Event emitted when a buyer contributes additional shares
    event SharesContributed(
        uint256 indexed tokenId,
        address indexed contributor,
        uint256 sharesContributed
    );

    // Add a reentrancy guard modifier
    bool private _locked;
    modifier nonReentrant() {
        require(!_locked, "ReentrancyGuard: reentrant call");
        _locked = true;
        _;
        _locked = false;
    }

    struct Auction {
        uint256 tokenId;
        address highestBidder;
        uint256 highestBid;
        uint256 endTime;
    }

    // Struct to store revenue distribution information
    struct RevenueDistribution {
        uint256 percentage; // Percentage of revenue to distribute
        address recipient; // Address to receive the distributed revenue
    }

    event NFTMinted(
        uint256 tokenId,
        address to,
        bool isFractional,
        string tokenUrl,
        string tokenName,
        string tokenDescription
    );

    event AuctionEnded(
        uint256 indexed tokenId,
        address indexed highestBidder,
        uint256 highestBid
    );

    mapping(uint256 => Auction) private _tokenAuctions;

    // Mapping to store ownership shares of each address for each token ID
    mapping(uint256 => mapping(address => uint256)) private _ownershipShares;

    // Mapping to store the list of owners of shares for each token ID
    mapping(uint256 => address[]) private _shareOwners;

    // Mapping to store revenue distribution settings for each token ID
    mapping(uint256 => RevenueDistribution[]) private _revenueDistribution;

    // Counter for the next available token ID
    uint256 private _nextTokenId = 1;

    mapping(uint256 => uint256) private _royaltyFees;

    // Mapping to store the sale price for each token ID
    mapping(uint256 => uint256) private _salePrices;

    // Mapping to store the edition size for each token ID
    mapping(uint256 => uint256) private _editionSizes;

    // Mapping to store the number of tokens minted for each edition
    mapping(uint256 => uint256) private _mintedEditions;

    //Mapping to store whether an NFT is fractional or not
    mapping(uint256 => bool) private _isFractional;

    // Function to set the sale price for an NFT
    function setSalePrice(
        uint256 tokenId,
        uint256 salePrice
    ) external onlyOwner {
        _salePrices[tokenId] = salePrice;
    }

    // Constructor to initialize the contract with a name and symbol
    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {}

    // Function to set the royalty fee for an NFT
    function setRoyaltyFee(
        uint256 tokenId,
        uint256 percentage
    ) external onlyOwner {
        require(percentage <= 100, "Invalid royalty percentage");
        _royaltyFees[tokenId] = percentage;
    }

    // Function to distribute royalty fees
    function distributeRoyalty(uint256 tokenId, uint256 amount) internal {
        uint256 royaltyPercentage = _royaltyFees[tokenId];
        uint256 royalty = (amount * royaltyPercentage) / 100;
        payable(ownerOf(tokenId)).transfer(royalty);
    }

    // Function to start an auction for a token
    function startAuction(
        uint256 tokenId,
        uint256 duration
    ) external onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        require(
            _tokenAuctions[tokenId].endTime == 0,
            "Auction already started"
        );

        // Set the auction details
        _tokenAuctions[tokenId] = Auction({
            tokenId: tokenId,
            highestBidder: address(0),
            highestBid: 0,
            endTime: block.timestamp + duration
        });
    }

    // Function to place a bid on an ongoing auction
    function placeBid(uint256 tokenId) external payable {
        Auction storage auction = _tokenAuctions[tokenId];

        // Check if the auction is ongoing
        require(block.timestamp < auction.endTime, "Auction has ended");

        // Check if the bid is higher than the current highest bid
        require(
            msg.value > auction.highestBid,
            "Bid must be higher than current highest bid"
        );

        // Refund the previous highest bidder
        if (auction.highestBidder != address(0)) {
            payable(auction.highestBidder).transfer(auction.highestBid);
        }

        // Update the highest bidder and highest bid
        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
    }

    // Function to end the auction and transfer the NFT to the highest bidder
    function endAuction(uint256 tokenId) external auctionEnded(tokenId) {
        Auction storage auction = _tokenAuctions[tokenId];

        // Ensure the auction has not ended yet
        require(auction.endTime > 0, "Auction does not exist");

        // Ensure the highest bidder is not the zero address
        require(auction.highestBidder != address(0), "No valid bids");

        // Transfer the NFT to the highest bidder
        _transfer(ownerOf(tokenId), auction.highestBidder, tokenId);

        // Emit an event indicating the end of the auction
        emit AuctionEnded(tokenId, auction.highestBidder, auction.highestBid);

        // Delete the auction
        delete _tokenAuctions[tokenId];
    }

    // Function for users to place bids
    function placeBid(uint256 tokenId) external payable {
        require(
            _tokenAuctions[tokenId].endTime > block.timestamp,
            "Auction ended"
        );
        require(msg.value > _tokenAuctions[tokenId].highestBid, "Bid too low");

        if (_tokenAuctions[tokenId].highestBidder != address(0)) {
            // Return funds to the previous highest bidder
            payable(_tokenAuctions[tokenId].highestBidder).transfer(
                _tokenAuctions[tokenId].highestBid
            );
        }

        // Update highest bidder and bid amount
        _tokenAuctions[tokenId].highestBidder = msg.sender;
        _tokenAuctions[tokenId].highestBid = msg.value;
    }

    function mint(
        address to,
        string memory tokenUrl,
        bool isFractional
    ) external onlyOwner {
        require(to != address(0), "Invalid address");
        require(_nextTokenId <= type(uint256).max, "Token ID overflow");

        // Assign the next available token ID
        uint256 tokenId = _nextTokenId;

        // Mint the NFT to the specified address
        _mint(to, tokenId);

        // Add the owner to the list of share owners
        _shareOwners[tokenId].push(to);

        // Store the NFT URL
        _setTokenURI(tokenId, tokenUrl);

        // Store whether the NFT is fractional or not
        _isFractional[tokenId] = isFractional;

        // Increment the next available token ID for the next minting
        _nextTokenId = tokenId + 1;
    }

    // Function to check if an NFT is fractional or not
    function isFractional(uint256 tokenId) external view returns (bool) {
        require(_exists(tokenId), "Token does not exist");
        return _isFractional[tokenId];
    }

    event DebugUint(uint256 value);
    event DebugString(string value);

    // Function to buy the NFT
    function buyToken(uint256 tokenId) external payable nonReentrant {
        require(_exists(tokenId), "Token does not exist");
        require(_salePrices[tokenId] > 0, "Sale price not set");

        uint256 salePrice = _salePrices[tokenId];

        // Ensure that the sent amount is at least equal to the sale price
        require(msg.value >= salePrice, "Insufficient funds");

        emit DebugUint(msg.value);
        emit DebugString(Strings.toString(salePrice));

        // Transfer ownership to the buyer
        _transfer(ownerOf(tokenId), msg.sender, tokenId);

        // Distribute revenue (you may adjust this based on your revenue distribution logic)
        uint256 royalty = (salePrice * 10) / 100; // Assuming 10% royalty
        payable(owner()).transfer(royalty);
        payable(ownerOf(tokenId)).transfer(msg.value - royalty);

        emit DebugString("Transaction successful");
    }

    // Function for the contract owner to transfer ownership shares to another address
    function transferShare(
        uint256 tokenId,
        address to,
        uint256 shares
    ) external onlyOwner {
        require(to != address(0), "Invalid address");
        require(
            shares > 0 && shares <= _ownershipShares[tokenId][msg.sender],
            "Invalid share amount"
        );

        // Transfer shares from the owner to the specified address using SafeMath
        _ownershipShares[tokenId][msg.sender] = _ownershipShares[tokenId][
            msg.sender
        ].sub(shares);
        _ownershipShares[tokenId][to] = _ownershipShares[tokenId][to].add(
            shares
        );

        // Add the new owner to the list of share owners if not already present
        if (!isAddressInArray(_shareOwners[tokenId], to)) {
            _shareOwners[tokenId].push(to);
        }

        // Emit events for debugging
        emit SharesTransferred(tokenId, msg.sender, to, shares);
        emit OwnershipSharesUpdated(
            tokenId,
            msg.sender,
            _ownershipShares[tokenId][msg.sender]
        );
        emit OwnershipSharesUpdated(tokenId, to, _ownershipShares[tokenId][to]);
    }

    event SharesTransferred(
        uint256 indexed tokenId,
        address indexed from,
        address indexed to,
        uint256 shares
    );

    event OwnershipSharesUpdated(
        uint256 indexed tokenId,
        address indexed owner,
        uint256 shares
    );

    // The contract keeps track of ownership shares for each address and each token ID in the `_ownershipShares` mapping.
    // Shares can be minted by the contract owner, transferred between addresses, and additional shares can be contributed by buyers.
    // The `_shareOwners` mapping is used to keep a list of owners of shares for each token ID.
    // The `contributeShares` function allows buyers to contribute additional shares to the NFT.
    // Function for a buyer to contribute additional shares to the NFT
    // Function for a buyer to contribute additional shares to the NFT

    function contributeShares(uint256 tokenId, uint256 percentage) external {
        require(percentage > 0 && percentage <= 100, "Invalid percentage");

        // Calculate the total shares of the NFT
        uint256 totalShares = calculateTotalShares(tokenId);

        // Calculate the ownership shares based on the provided percentage
        uint256 sharesToContribute = (totalShares * percentage) / 100;

        // Transfer ownership shares from the buyer to each existing owner
        address[] storage owners = _shareOwners[tokenId];
        for (uint256 i = 0; i < owners.length; i++) {
            address owner = owners[i];
            uint256 ownerShare = (_ownershipShares[tokenId][owner] *
                sharesToContribute) / totalShares;

            // Transfer ownership shares
            _ownershipShares[tokenId][msg.sender] += ownerShare;
            _ownershipShares[tokenId][owner] -= ownerShare;
        }

        // Add the new owner to the list of share owners if not already present
        if (!isAddressInArray(owners, msg.sender)) {
            owners.push(msg.sender);
        }

        // Emit an event indicating the contribution of shares
        emit SharesContributed(tokenId, msg.sender, sharesToContribute);
    }

    function calculateTotalShares(
        uint256 tokenId
    ) internal view returns (uint256) {
        uint256 totalShares = 0;
        address[] storage owners = _shareOwners[tokenId];

        for (uint256 i = 0; i < owners.length; i++) {
            totalShares += _ownershipShares[tokenId][owners[i]];
        }
        return totalShares;
    }

    // Function to get the number of shares owned by a specific address for a given token ID
    function getOwnedShares(
        uint256 tokenId,
        address owner
    ) external view returns (uint256) {
        return _ownershipShares[tokenId][owner];
    }

    // Function to get the list of owners of shares for a given token ID
    function getShareOwners(
        uint256 tokenId
    ) external view returns (address[] memory) {
        return _shareOwners[tokenId];
    }

    //generally a good idea to restrict the ability to add revenue distribution settings
    // for a token ID to the contract owner This is because revenue distribution settings
    //can have a significant impact on the value of an NFT, and it is important to ensure
    //that only authorized individuals can make changes to these settings.
    // Function to add revenue distribution settings for a token ID

    function addRevenueDistribution(
        uint256 tokenId,
        uint256 percentage,
        //The recipient address in the addRevenueDistribution() function is the address
        // of the person or organization that will receive a percentage of the revenue
        //from the sale of the token with the given ID. This could be the creator of the
        //token, the owner of the token, or any other address that you specify.

        address recipient
    ) external onlyOwner {
        require(percentage <= 100, "Invalid percentage");
        require(recipient != address(0), "Invalid recipient address");

        // Add revenue distribution settings for the token ID
        _revenueDistribution[tokenId].push(
            RevenueDistribution({percentage: percentage, recipient: recipient})
        );
    }

    // Function to remove revenue distribution settings for a token ID
    function removeRevenueDistribution(
        uint256 tokenId,
        uint256 index
    ) external onlyOwner {
        require(index < _revenueDistribution[tokenId].length, "Invalid index");

        // Remove revenue distribution settings at the specified index
        for (
            uint256 i = index;
            i < _revenueDistribution[tokenId].length - 1;
            i++
        ) {
            _revenueDistribution[tokenId][i] = _revenueDistribution[tokenId][
                i + 1
            ];
        }

        // Trim the array to remove the last element
        _revenueDistribution[tokenId].pop();
    }

    // Function to distribute revenue for a token ID
    function distributeRevenue(
        uint256 tokenId,
        uint256 amount
    ) external onlyOwner nonReentrant {
        require(amount > 0, "Invalid amount");
        require(
            _revenueDistribution[tokenId].length > 0,
            "No revenue distribution settings"
        );

        uint256 totalPercentage = 0;
        for (uint256 i = 0; i < _revenueDistribution[tokenId].length; i++) {
            totalPercentage += _revenueDistribution[tokenId][i].percentage;
        }

        require(totalPercentage == 100, "Invalid total percentage");

        for (uint256 i = 0; i < _revenueDistribution[tokenId].length; i++) {
            uint256 recipientShare = (amount *
                _revenueDistribution[tokenId][i].percentage) / 100;
            // Use a require statement to check if the transfer was successful
            require(
                payable(_revenueDistribution[tokenId][i].recipient).send(
                    recipientShare
                ),
                "Transfer failed"
            );
        }

        emit RevenueDistributed(tokenId, amount, block.timestamp);
    }

    // Function for the contract owner to withdraw revenue from the contract
    function withdrawRevenue(uint256 amount) external onlyOwner {
        require(amount > 0, "Invalid amount");
        require(
            address(this).balance >= amount,
            "Insufficient contract balance"
        );

        // Transfer revenue to the contract owner
        payable(owner()).transfer(amount);
    }

    // Internal function to check if an address is in an array
    function isAddressInArray(
        address[] memory array,
        address element
    ) internal pure returns (bool) {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == element) {
                return true;
            }
        }
        return false;
    }
}
