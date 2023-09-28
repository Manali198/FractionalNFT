// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract FractionalOwnershipNFT is Ownable, ERC721URIStorage {
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

    // Struct to store revenue distribution information
    struct RevenueDistribution {
        uint256 percentage; // Percentage of revenue to distribute
        address recipient; // Address to receive the distributed revenue
    }

    // Mapping to store ownership shares of each address for each token ID
    mapping(uint256 => mapping(address => uint256)) private _ownershipShares;

    // Mapping to store the list of owners of shares for each token ID
    mapping(uint256 => address[]) private _shareOwners;

    // Mapping to store revenue distribution settings for each token ID
    mapping(uint256 => RevenueDistribution[]) private _revenueDistribution;

    // Counter for the next available token ID
    uint256 private _nextTokenId = 1;

    // Constructor to initialize the contract with a name and symbol
    constructor(
        string memory name,
        string memory symbol
    ) ERC721(name, symbol) {}

    function mint(
        address to,
        uint256 shares,
        string memory tokenUrl
    ) external onlyOwner {
        require(to != address(0), "Invalid address");
        require(
            _nextTokenId <= type(uint256).max - shares,
            "Token ID overflow"
        );

        // Assign the next available token ID
        uint256 tokenId = _nextTokenId;

        // Mint the NFT to the specified address
        _mint(to, tokenId);

        // Update total supply and ownership shares
        _ownershipShares[tokenId][to] = shares;

        // Add the owner to the list of share owners
        _shareOwners[tokenId].push(to);

        // Store the NFT URL
        _setTokenURI(tokenId, tokenUrl);

        // Increment the next available token ID for the next minting
        _nextTokenId = tokenId + 1;
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
