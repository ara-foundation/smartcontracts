// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Ara Projects
 * @author Medet Ahmetson
 * @notice Version 1.
 */
contract SharedV1 {
    struct Sangha {
        address ownership; // DAO token
        address maintainer; // Maintainer token
        address check; // Check token
    }

    struct Project {
        bool active;    // if the project is cancelled
        
        //
        // Data
        //    
        string name;    // project name
        string logos;   // the hardcoded logos snapshotted.
        string aurora;  // the hardcoded aurora snapshotted.

        string techStack;
        uint256 costUsd;
        uint256 duration; // An ACT stage duration
        string sourceCodeUrl;
        string testUrl;

        // Dynamic data set by Maydone
        uint256 startTime; // An ACT stage start time
    }
}