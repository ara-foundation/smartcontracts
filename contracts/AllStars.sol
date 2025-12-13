// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Star} from "./Star.sol";

/**
 * @title AllStars
 * @notice Ara All Stars, a universe of open-source project galaxies, and user stars in the galaxy.
 * @author Medet Ahmetson <medet@ara.foundation>
 */
contract AllStars is AccessControlUpgradeable {
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

    // Universe space coordinates
    Space public universeSpace;
    // Mapping of galaxy ID to galaxy data
    mapping(uint256 => GalaxyData) public galaxies;
    // Mapping of galaxy ID to solarForge tracking
    mapping(uint256 => mapping(string => mapping(string => bool))) public solarForged;

    event GalaxyCreated(uint256 indexed id, address indexed owner, address indexed star, string name);
    event GalaxyAdded(uint256 indexed id, address indexed owner, address indexed star, string name, uint256 minX, uint256 maxX, uint256 minY, uint256 maxY);
    event SolarForged(uint256 indexed galaxyId, uint256 remainingStars, uint256 forgedStars, uint256 totalUsers);
    event ThresholdReached(uint256 indexed galaxyId, address newOwner);
    event GalaxySpaceSizeChanged(uint256 indexed galaxyId, uint256 minX, uint256 maxX, uint256 minY, uint256 maxY);
    event UniverseSpaceSizeChanged(uint256 minX, uint256 maxX, uint256 minY, uint256 maxY);

    modifier onlyBackend() {
        require(hasRole(BACKEND_ROLE, msg.sender), "not backend");
        _;
    }

    function initialize() public initializer {
        __AccessControl_init();
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(BACKEND_ROLE, msg.sender);

        // Set default universe space to laptop screen size
        universeSpace = Space({
            minX: 0,
            maxX: 1600,
            minY: 0,
            maxY: 800
        });
    }

    function addGalaxy(
        address owner_,
        string memory repoUrl_,
        string memory issuesUrl_,
        string memory name_,
        uint256 id_,
        uint256 minX,
        uint256 maxX,
        uint256 minY,
        uint256 maxY
    ) external onlyBackend {
        require(galaxies[id_].id == 0, "galaxy already exists");

        // Set galaxy space coordinates
        Space memory galaxySpace = Space({
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY
        });

        // Deploy Star token
        string memory starName = string.concat(name_, " Star");
        Star starToken = new Star(starName, "STAR", address(this));

        // Create galaxy
        galaxies[id_] = GalaxyData({
            owner: owner_,
            starsThreshold: 100000,
            star: address(starToken),
            repoUrl: repoUrl_,
            issuesUrl: issuesUrl_,
            name: name_,
            id: id_,
            space: galaxySpace
        });

        // Update universe space if galaxy coordinates extend beyond current universe bounds
        bool universeChanged = false;
        if (minX < universeSpace.minX) {
            universeSpace.minX = minX;
            universeChanged = true;
        }
        if (maxX > universeSpace.maxX) {
            universeSpace.maxX = maxX;
            universeChanged = true;
        }
        if (minY < universeSpace.minY) {
            universeSpace.minY = minY;
            universeChanged = true;
        }
        if (maxY > universeSpace.maxY) {
            universeSpace.maxY = maxY;
            universeChanged = true;
        }

        if (universeChanged) {
            emit UniverseSpaceSizeChanged(universeSpace.minX, universeSpace.maxX, universeSpace.minY, universeSpace.maxY);
        }

        emit GalaxyAdded(id_, owner_, address(starToken), name_, minX, maxX, minY, maxY);
    }

    function solarForge(uint256 galaxyId, SolarForge[] calldata models) external onlyBackend {
        GalaxyData storage galaxy = galaxies[galaxyId];
        require(galaxy.id != 0, "galaxy not found");

        uint256 totalForgedStars = 0;
        uint256 totalUsers = 0;
        uint256 totalStarsToForge = 0;

        // First pass: validate and calculate totals
        for (uint256 i = 0; i < models.length; i++) {
            SolarForge calldata model = models[i];
            require(!solarForged[galaxyId][model.solarForgeType][model.issueId], "solarForged");
            totalStarsToForge += model.stars;
        }

        // Second pass: process each model
        for (uint256 i = 0; i < models.length; i++) {
            SolarForge calldata model = models[i];
            
            // Mark as forged
            solarForged[galaxyId][model.solarForgeType][model.issueId] = true;

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
            emit ThresholdReached(galaxyId, galaxy.star);
        }

        uint256 remainingStars = totalStarsToForge - totalForgedStars;
        emit SolarForged(galaxyId, remainingStars, totalForgedStars, totalUsers);
    }

    /**
     * @notice Sets the user's position on the galaxy map
     */
    function spaceCoord(uint256 galaxyId, address userId, uint256 x, uint256 y) external onlyBackend {
        GalaxyData storage galaxy = galaxies[galaxyId];
        require(galaxy.id != 0, "galaxy not found");

        bool success = Star(galaxy.star).setPosition(userId, x, y);
        require(success, "setPosition failed");

        bool galaxySpaceChanged = false;
        bool universeChanged = false;

        // Update galaxy space boundaries if needed
        if (x < galaxy.space.minX) {
            galaxy.space.minX = x;
            galaxySpaceChanged = true;
            if (x < universeSpace.minX) {
                universeSpace.minX = x;
                universeChanged = true;
            }
        }
        if (x > galaxy.space.maxX) {
            galaxy.space.maxX = x;
            galaxySpaceChanged = true;
            if (x > universeSpace.maxX) {
                universeSpace.maxX = x;
                universeChanged = true;
            }
        }
        if (y < galaxy.space.minY) {
            galaxy.space.minY = y;
            galaxySpaceChanged = true;
            if (y < universeSpace.minY) {
                universeSpace.minY = y;
                universeChanged = true;
            }
        }
        if (y > galaxy.space.maxY) {
            galaxy.space.maxY = y;
            galaxySpaceChanged = true;
            if (y > universeSpace.maxY) {
                universeSpace.maxY = y;
                universeChanged = true;
            }
        }

        if (galaxySpaceChanged) {
            emit GalaxySpaceSizeChanged(galaxyId, galaxy.space.minX, galaxy.space.maxX, galaxy.space.minY, galaxy.space.maxY);
        }

        if (universeChanged) {
            emit UniverseSpaceSizeChanged(universeSpace.minX, universeSpace.maxX, universeSpace.minY, universeSpace.maxY);
        }
    }
}
