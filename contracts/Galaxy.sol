// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Star} from "./Star.sol";

/**
 * @title Galaxy
 * @notice Each open source project is a galaxy.
 * Galaxy has the stars issued for resolved issues.
 * Goal is to gather as many stars as possible, once the star amount exceeds a certain threshold,
 * open source project in Ara changes it's owner to the star owners: users, collaborators along with the maintainers.
 * @author Medet Ahmetson <medet@ara.foundation>
 */
contract Galaxy is Initializable, AccessControlUpgradeable {
    bytes32 public constant BACKEND_ROLE = keccak256("BACKEND_ROLE");

    struct Space {
        uint256 minX;
        uint256 maxX;
        uint256 minY;
        uint256 maxY;
    }

    struct GalaxyData {
        address owner;
        uint256 starsThreshold;
        address star;
        string repoUrl;
        string issuesUrl;
        string name;
        uint256 id;
        Space space;
    }

    struct SolarForge {
        string _id;
        string solarForgeType;
        string issueId;
        address[] users;
        uint256 stars;
    }

    GalaxyData public galaxy;
    mapping(string => mapping(string => bool)) public solarForged;

    event GalaxyCreated(uint256 indexed id, address indexed owner, address indexed star, string name);
    event SolarForged(uint256 remainingStars, uint256 forgedStars, uint256 totalUsers);
    event ThresholdReached(uint256 indexed galaxyId, address newOwner);
    event SpaceSizeChanged(uint256 minX, uint256 maxX, uint256 minY, uint256 maxY);

    modifier onlyBackend() {
        require(hasRole(BACKEND_ROLE, msg.sender), "not backend");
        _;
    }

    function initialize(
        address owner_,
        string memory repoUrl_,
        string memory issuesUrl_,
        string memory name_,
        uint256 id_
    ) public initializer {
        __AccessControl_init();
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        // Set default space to laptop screen size
        Space memory defaultSpace = Space({
            minX: 0,
            maxX: 1600,
            minY: 0,
            maxY: 800
        });

        // Deploy Star token
        string memory starName = string.concat(name_, " Star");
        Star starToken = new Star(starName, "STAR", address(this));

        // Initialize Galaxy struct
        galaxy = GalaxyData({
            owner: owner_,
            starsThreshold: 100000,
            star: address(starToken),
            repoUrl: repoUrl_,
            issuesUrl: issuesUrl_,
            name: name_,
            id: id_,
            space: defaultSpace
        });

        emit GalaxyCreated(id_, owner_, address(starToken), name_);
    }

    function solarForge(SolarForge[] calldata models) external onlyBackend {
        uint256 totalForgedStars = 0;
        uint256 totalUsers = 0;
        uint256 totalStarsToForge = 0;

        // First pass: validate and calculate totals
        for (uint256 i = 0; i < models.length; i++) {
            SolarForge calldata model = models[i];
            require(!solarForged[model.solarForgeType][model.issueId], "solarForged");
            totalStarsToForge += model.stars;
        }

        // Second pass: process each model
        for (uint256 i = 0; i < models.length; i++) {
            SolarForge calldata model = models[i];
            
            // Mark as forged
            solarForged[model.solarForgeType][model.issueId] = true;

            // Calculate stars per user
            require(model.users.length > 0, "no users");
            uint256 starsPerUser = model.stars / model.users.length;

            // Mint stars to each user
            for (uint256 j = 0; j < model.users.length; j++) {
                Star(galaxy.star).mint(model.users[j], starsPerUser);
            }

            totalForgedStars += starsPerUser * model.users.length;
            totalUsers += model.users.length;
        }

        // Check threshold
        uint256 currentSupply = IERC20(galaxy.star).totalSupply();
        if (currentSupply >= galaxy.starsThreshold) {
            galaxy.owner = galaxy.star;
            Star(galaxy.star).enableTransfers();
            emit ThresholdReached(galaxy.id, galaxy.star);
        }

        uint256 remainingStars = totalStarsToForge - totalForgedStars;
        emit SolarForged(remainingStars, totalForgedStars, totalUsers);
    }

    /**
     * @notice Sets the user's position on the galaxy map
     */
    function spaceCoord(address userId, uint256 x, uint256 y) external onlyBackend {
        bool success = Star(galaxy.star).setPosition(userId, x, y);
        require(success, "setPosition failed");

        bool spaceChanged = false;

        // Update space boundaries if needed
        if (x < galaxy.space.minX) {
            galaxy.space.minX = x;
            spaceChanged = true;
        }
        if (x > galaxy.space.maxX) {
            galaxy.space.maxX = x;
            spaceChanged = true;
        }
        if (y < galaxy.space.minY) {
            galaxy.space.minY = y;
            spaceChanged = true;
        }
        if (y > galaxy.space.maxY) {
            galaxy.space.maxY = y;
            spaceChanged = true;
        }

        if (spaceChanged) {
            emit SpaceSizeChanged(galaxy.space.minX, galaxy.space.maxX, galaxy.space.minY, galaxy.space.maxY);
        }
    }
}
