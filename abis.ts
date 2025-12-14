import {
  createReadContract,
  createWriteContract,
  createSimulateContract,
  createWatchContractEvent,
} from '@wagmi/core/codegen'

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// AllStars
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const allStarsAbi = [
  { type: 'error', inputs: [], name: 'AccessControlBadConfirmation' },
  {
    type: 'error',
    inputs: [
      { name: 'account', internalType: 'address', type: 'address' },
      { name: 'neededRole', internalType: 'bytes32', type: 'bytes32' },
    ],
    name: 'AccessControlUnauthorizedAccount',
  },
  { type: 'error', inputs: [], name: 'InvalidInitialization' },
  { type: 'error', inputs: [], name: 'NotInitializing' },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      { name: 'id', internalType: 'uint256', type: 'uint256', indexed: true },
      {
        name: 'owner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      { name: 'star', internalType: 'address', type: 'address', indexed: true },
      { name: 'name', internalType: 'string', type: 'string', indexed: false },
      {
        name: 'minX',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: 'maxX',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: 'minY',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: 'maxY',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'GalaxyAdded',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      { name: 'id', internalType: 'uint256', type: 'uint256', indexed: true },
      {
        name: 'owner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      { name: 'star', internalType: 'address', type: 'address', indexed: true },
      { name: 'name', internalType: 'string', type: 'string', indexed: false },
    ],
    name: 'GalaxyCreated',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'galaxyId',
        internalType: 'uint256',
        type: 'uint256',
        indexed: true,
      },
      {
        name: 'minX',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: 'maxX',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: 'minY',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: 'maxY',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'GalaxySpaceSizeChanged',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'version',
        internalType: 'uint64',
        type: 'uint64',
        indexed: false,
      },
    ],
    name: 'Initialized',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      { name: 'role', internalType: 'bytes32', type: 'bytes32', indexed: true },
      {
        name: 'previousAdminRole',
        internalType: 'bytes32',
        type: 'bytes32',
        indexed: true,
      },
      {
        name: 'newAdminRole',
        internalType: 'bytes32',
        type: 'bytes32',
        indexed: true,
      },
    ],
    name: 'RoleAdminChanged',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      { name: 'role', internalType: 'bytes32', type: 'bytes32', indexed: true },
      {
        name: 'account',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'sender',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'RoleGranted',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      { name: 'role', internalType: 'bytes32', type: 'bytes32', indexed: true },
      {
        name: 'account',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'sender',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'RoleRevoked',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'galaxyId',
        internalType: 'uint256',
        type: 'uint256',
        indexed: true,
      },
      {
        name: 'remainingStars',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: 'forgedStars',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: 'totalUsers',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'SolarForged',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'galaxyId',
        internalType: 'uint256',
        type: 'uint256',
        indexed: true,
      },
      {
        name: 'newOwner',
        internalType: 'address',
        type: 'address',
        indexed: false,
      },
    ],
    name: 'ThresholdReached',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'minX',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: 'maxX',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: 'minY',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
      {
        name: 'maxY',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'UniverseSpaceSizeChanged',
  },
  {
    type: 'function',
    inputs: [],
    name: 'BACKEND_ROLE',
    outputs: [{ name: '', internalType: 'bytes32', type: 'bytes32' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'DEFAULT_ADMIN_ROLE',
    outputs: [{ name: '', internalType: 'bytes32', type: 'bytes32' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'owner_', internalType: 'address', type: 'address' },
      { name: 'repoUrl_', internalType: 'string', type: 'string' },
      { name: 'issuesUrl_', internalType: 'string', type: 'string' },
      { name: 'name_', internalType: 'string', type: 'string' },
      { name: 'id_', internalType: 'uint256', type: 'uint256' },
      { name: 'minX', internalType: 'uint256', type: 'uint256' },
      { name: 'maxX', internalType: 'uint256', type: 'uint256' },
      { name: 'minY', internalType: 'uint256', type: 'uint256' },
      { name: 'maxY', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'addGalaxy',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    name: 'galaxies',
    outputs: [
      { name: 'owner', internalType: 'address', type: 'address' },
      { name: 'starsThreshold', internalType: 'uint256', type: 'uint256' },
      { name: 'star', internalType: 'address', type: 'address' },
      { name: 'repoUrl', internalType: 'string', type: 'string' },
      { name: 'issuesUrl', internalType: 'string', type: 'string' },
      { name: 'name', internalType: 'string', type: 'string' },
      { name: 'id', internalType: 'uint256', type: 'uint256' },
      {
        name: 'space',
        internalType: 'struct AllStars.Space',
        type: 'tuple',
        components: [
          { name: 'minX', internalType: 'uint256', type: 'uint256' },
          { name: 'maxX', internalType: 'uint256', type: 'uint256' },
          { name: 'minY', internalType: 'uint256', type: 'uint256' },
          { name: 'maxY', internalType: 'uint256', type: 'uint256' },
        ],
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: 'role', internalType: 'bytes32', type: 'bytes32' }],
    name: 'getRoleAdmin',
    outputs: [{ name: '', internalType: 'bytes32', type: 'bytes32' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'role', internalType: 'bytes32', type: 'bytes32' },
      { name: 'account', internalType: 'address', type: 'address' },
    ],
    name: 'grantRole',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'role', internalType: 'bytes32', type: 'bytes32' },
      { name: 'account', internalType: 'address', type: 'address' },
    ],
    name: 'hasRole',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: 'admin', internalType: 'address', type: 'address' }],
    name: 'initialize',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'role', internalType: 'bytes32', type: 'bytes32' },
      { name: 'callerConfirmation', internalType: 'address', type: 'address' },
    ],
    name: 'renounceRole',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'role', internalType: 'bytes32', type: 'bytes32' },
      { name: 'account', internalType: 'address', type: 'address' },
    ],
    name: 'revokeRole',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'galaxyId', internalType: 'uint256', type: 'uint256' },
      {
        name: 'models',
        internalType: 'struct AllStars.SolarForge[]',
        type: 'tuple[]',
        components: [
          { name: '_id', internalType: 'string', type: 'string' },
          { name: 'solarForgeType', internalType: 'string', type: 'string' },
          { name: 'issueId', internalType: 'string', type: 'string' },
          { name: 'users', internalType: 'address[]', type: 'address[]' },
          { name: 'stars', internalType: 'uint256', type: 'uint256' },
        ],
      },
    ],
    name: 'solarForge',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: '', internalType: 'uint256', type: 'uint256' },
      { name: '', internalType: 'string', type: 'string' },
      { name: '', internalType: 'string', type: 'string' },
    ],
    name: 'solarForged',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'galaxyId', internalType: 'uint256', type: 'uint256' },
      { name: 'userId', internalType: 'address', type: 'address' },
      { name: 'x', internalType: 'uint256', type: 'uint256' },
      { name: 'y', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'spaceCoord',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: 'interfaceId', internalType: 'bytes4', type: 'bytes4' }],
    name: 'supportsInterface',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'universeSpace',
    outputs: [
      { name: 'minX', internalType: 'uint256', type: 'uint256' },
      { name: 'maxX', internalType: 'uint256', type: 'uint256' },
      { name: 'minY', internalType: 'uint256', type: 'uint256' },
      { name: 'maxY', internalType: 'uint256', type: 'uint256' },
    ],
    stateMutability: 'view',
  },
] as const

/**
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const allStarsAddress = {
  84532: '0x70b089840FB3D567C5d618b222503d68A8ad0dAa',
} as const

/**
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const allStarsConfig = {
  address: allStarsAddress,
  abi: allStarsAbi,
} as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ProxyWrapper
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const proxyWrapperAbi = [
  {
    type: 'constructor',
    inputs: [
      { name: 'implementation', internalType: 'address', type: 'address' },
      { name: 'admin', internalType: 'address', type: 'address' },
      { name: '_data', internalType: 'bytes', type: 'bytes' },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'error',
    inputs: [{ name: 'target', internalType: 'address', type: 'address' }],
    name: 'AddressEmptyCode',
  },
  {
    type: 'error',
    inputs: [{ name: 'admin', internalType: 'address', type: 'address' }],
    name: 'ERC1967InvalidAdmin',
  },
  {
    type: 'error',
    inputs: [
      { name: 'implementation', internalType: 'address', type: 'address' },
    ],
    name: 'ERC1967InvalidImplementation',
  },
  { type: 'error', inputs: [], name: 'ERC1967NonPayable' },
  { type: 'error', inputs: [], name: 'FailedInnerCall' },
  { type: 'error', inputs: [], name: 'ProxyDeniedAdminAccess' },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'previousAdmin',
        internalType: 'address',
        type: 'address',
        indexed: false,
      },
      {
        name: 'newAdmin',
        internalType: 'address',
        type: 'address',
        indexed: false,
      },
    ],
    name: 'AdminChanged',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'implementation',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
    ],
    name: 'Upgraded',
  },
  { type: 'fallback', stateMutability: 'payable' },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Star
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

export const starAbi = [
  {
    type: 'constructor',
    inputs: [
      { name: 'name', internalType: 'string', type: 'string' },
      { name: 'symbol', internalType: 'string', type: 'string' },
      { name: 'galaxy_', internalType: 'address', type: 'address' },
    ],
    stateMutability: 'nonpayable',
  },
  {
    type: 'error',
    inputs: [
      { name: 'spender', internalType: 'address', type: 'address' },
      { name: 'allowance', internalType: 'uint256', type: 'uint256' },
      { name: 'needed', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'ERC20InsufficientAllowance',
  },
  {
    type: 'error',
    inputs: [
      { name: 'sender', internalType: 'address', type: 'address' },
      { name: 'balance', internalType: 'uint256', type: 'uint256' },
      { name: 'needed', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'ERC20InsufficientBalance',
  },
  {
    type: 'error',
    inputs: [{ name: 'approver', internalType: 'address', type: 'address' }],
    name: 'ERC20InvalidApprover',
  },
  {
    type: 'error',
    inputs: [{ name: 'receiver', internalType: 'address', type: 'address' }],
    name: 'ERC20InvalidReceiver',
  },
  {
    type: 'error',
    inputs: [{ name: 'sender', internalType: 'address', type: 'address' }],
    name: 'ERC20InvalidSender',
  },
  {
    type: 'error',
    inputs: [{ name: 'spender', internalType: 'address', type: 'address' }],
    name: 'ERC20InvalidSpender',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      {
        name: 'owner',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'spender',
        internalType: 'address',
        type: 'address',
        indexed: true,
      },
      {
        name: 'value',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'Approval',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      { name: 'user', internalType: 'address', type: 'address', indexed: true },
      { name: 'x', internalType: 'uint256', type: 'uint256', indexed: false },
      { name: 'y', internalType: 'uint256', type: 'uint256', indexed: false },
    ],
    name: 'PositionSet',
  },
  {
    type: 'event',
    anonymous: false,
    inputs: [
      { name: 'from', internalType: 'address', type: 'address', indexed: true },
      { name: 'to', internalType: 'address', type: 'address', indexed: true },
      {
        name: 'value',
        internalType: 'uint256',
        type: 'uint256',
        indexed: false,
      },
    ],
    name: 'Transfer',
  },
  {
    type: 'function',
    inputs: [
      { name: 'owner', internalType: 'address', type: 'address' },
      { name: 'spender', internalType: 'address', type: 'address' },
    ],
    name: 'allowance',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'spender', internalType: 'address', type: 'address' },
      { name: 'value', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'approve',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [{ name: 'account', internalType: 'address', type: 'address' }],
    name: 'balanceOf',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [{ name: '', internalType: 'address', type: 'address' }],
    name: 'coords',
    outputs: [
      { name: 'x', internalType: 'uint256', type: 'uint256' },
      { name: 'y', internalType: 'uint256', type: 'uint256' },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'decimals',
    outputs: [{ name: '', internalType: 'uint8', type: 'uint8' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'enableTransfers',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'galaxy',
    outputs: [{ name: '', internalType: 'address', type: 'address' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'to', internalType: 'address', type: 'address' },
      { name: 'amount', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'mint',
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'name',
    outputs: [{ name: '', internalType: 'string', type: 'string' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'user', internalType: 'address', type: 'address' },
      { name: 'x', internalType: 'uint256', type: 'uint256' },
      { name: 'y', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'setPosition',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'symbol',
    outputs: [{ name: '', internalType: 'string', type: 'string' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [],
    name: 'totalSupply',
    outputs: [{ name: '', internalType: 'uint256', type: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    inputs: [
      { name: 'to', internalType: 'address', type: 'address' },
      { name: 'amount', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'transfer',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [
      { name: 'from', internalType: 'address', type: 'address' },
      { name: 'to', internalType: 'address', type: 'address' },
      { name: 'amount', internalType: 'uint256', type: 'uint256' },
    ],
    name: 'transferFrom',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    inputs: [],
    name: 'transfersEnabled',
    outputs: [{ name: '', internalType: 'bool', type: 'bool' }],
    stateMutability: 'view',
  },
] as const

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Action
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link allStarsAbi}__
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const readAllStars = /*#__PURE__*/ createReadContract({
  abi: allStarsAbi,
  address: allStarsAddress,
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"BACKEND_ROLE"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const readAllStarsBackendRole = /*#__PURE__*/ createReadContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'BACKEND_ROLE',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"DEFAULT_ADMIN_ROLE"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const readAllStarsDefaultAdminRole = /*#__PURE__*/ createReadContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'DEFAULT_ADMIN_ROLE',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"galaxies"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const readAllStarsGalaxies = /*#__PURE__*/ createReadContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'galaxies',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"getRoleAdmin"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const readAllStarsGetRoleAdmin = /*#__PURE__*/ createReadContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'getRoleAdmin',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"hasRole"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const readAllStarsHasRole = /*#__PURE__*/ createReadContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'hasRole',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"solarForged"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const readAllStarsSolarForged = /*#__PURE__*/ createReadContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'solarForged',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"supportsInterface"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const readAllStarsSupportsInterface = /*#__PURE__*/ createReadContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'supportsInterface',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"universeSpace"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const readAllStarsUniverseSpace = /*#__PURE__*/ createReadContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'universeSpace',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link allStarsAbi}__
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const writeAllStars = /*#__PURE__*/ createWriteContract({
  abi: allStarsAbi,
  address: allStarsAddress,
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"addGalaxy"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const writeAllStarsAddGalaxy = /*#__PURE__*/ createWriteContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'addGalaxy',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"grantRole"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const writeAllStarsGrantRole = /*#__PURE__*/ createWriteContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'grantRole',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"initialize"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const writeAllStarsInitialize = /*#__PURE__*/ createWriteContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'initialize',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"renounceRole"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const writeAllStarsRenounceRole = /*#__PURE__*/ createWriteContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'renounceRole',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"revokeRole"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const writeAllStarsRevokeRole = /*#__PURE__*/ createWriteContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'revokeRole',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"solarForge"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const writeAllStarsSolarForge = /*#__PURE__*/ createWriteContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'solarForge',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"spaceCoord"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const writeAllStarsSpaceCoord = /*#__PURE__*/ createWriteContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'spaceCoord',
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link allStarsAbi}__
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const simulateAllStars = /*#__PURE__*/ createSimulateContract({
  abi: allStarsAbi,
  address: allStarsAddress,
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"addGalaxy"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const simulateAllStarsAddGalaxy = /*#__PURE__*/ createSimulateContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'addGalaxy',
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"grantRole"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const simulateAllStarsGrantRole = /*#__PURE__*/ createSimulateContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'grantRole',
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"initialize"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const simulateAllStarsInitialize = /*#__PURE__*/ createSimulateContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'initialize',
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"renounceRole"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const simulateAllStarsRenounceRole =
  /*#__PURE__*/ createSimulateContract({
    abi: allStarsAbi,
    address: allStarsAddress,
    functionName: 'renounceRole',
  })

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"revokeRole"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const simulateAllStarsRevokeRole = /*#__PURE__*/ createSimulateContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'revokeRole',
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"solarForge"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const simulateAllStarsSolarForge = /*#__PURE__*/ createSimulateContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'solarForge',
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link allStarsAbi}__ and `functionName` set to `"spaceCoord"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const simulateAllStarsSpaceCoord = /*#__PURE__*/ createSimulateContract({
  abi: allStarsAbi,
  address: allStarsAddress,
  functionName: 'spaceCoord',
})

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link allStarsAbi}__
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const watchAllStarsEvent = /*#__PURE__*/ createWatchContractEvent({
  abi: allStarsAbi,
  address: allStarsAddress,
})

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link allStarsAbi}__ and `eventName` set to `"GalaxyAdded"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const watchAllStarsGalaxyAddedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: allStarsAbi,
    address: allStarsAddress,
    eventName: 'GalaxyAdded',
  })

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link allStarsAbi}__ and `eventName` set to `"GalaxyCreated"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const watchAllStarsGalaxyCreatedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: allStarsAbi,
    address: allStarsAddress,
    eventName: 'GalaxyCreated',
  })

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link allStarsAbi}__ and `eventName` set to `"GalaxySpaceSizeChanged"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const watchAllStarsGalaxySpaceSizeChangedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: allStarsAbi,
    address: allStarsAddress,
    eventName: 'GalaxySpaceSizeChanged',
  })

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link allStarsAbi}__ and `eventName` set to `"Initialized"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const watchAllStarsInitializedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: allStarsAbi,
    address: allStarsAddress,
    eventName: 'Initialized',
  })

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link allStarsAbi}__ and `eventName` set to `"RoleAdminChanged"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const watchAllStarsRoleAdminChangedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: allStarsAbi,
    address: allStarsAddress,
    eventName: 'RoleAdminChanged',
  })

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link allStarsAbi}__ and `eventName` set to `"RoleGranted"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const watchAllStarsRoleGrantedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: allStarsAbi,
    address: allStarsAddress,
    eventName: 'RoleGranted',
  })

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link allStarsAbi}__ and `eventName` set to `"RoleRevoked"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const watchAllStarsRoleRevokedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: allStarsAbi,
    address: allStarsAddress,
    eventName: 'RoleRevoked',
  })

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link allStarsAbi}__ and `eventName` set to `"SolarForged"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const watchAllStarsSolarForgedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: allStarsAbi,
    address: allStarsAddress,
    eventName: 'SolarForged',
  })

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link allStarsAbi}__ and `eventName` set to `"ThresholdReached"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const watchAllStarsThresholdReachedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: allStarsAbi,
    address: allStarsAddress,
    eventName: 'ThresholdReached',
  })

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link allStarsAbi}__ and `eventName` set to `"UniverseSpaceSizeChanged"`
 *
 * [__View Contract on Base Sepolia Basescan__](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
 */
export const watchAllStarsUniverseSpaceSizeChangedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: allStarsAbi,
    address: allStarsAddress,
    eventName: 'UniverseSpaceSizeChanged',
  })

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link proxyWrapperAbi}__
 */
export const watchProxyWrapperEvent = /*#__PURE__*/ createWatchContractEvent({
  abi: proxyWrapperAbi,
})

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link proxyWrapperAbi}__ and `eventName` set to `"AdminChanged"`
 */
export const watchProxyWrapperAdminChangedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: proxyWrapperAbi,
    eventName: 'AdminChanged',
  })

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link proxyWrapperAbi}__ and `eventName` set to `"Upgraded"`
 */
export const watchProxyWrapperUpgradedEvent =
  /*#__PURE__*/ createWatchContractEvent({
    abi: proxyWrapperAbi,
    eventName: 'Upgraded',
  })

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link starAbi}__
 */
export const readStar = /*#__PURE__*/ createReadContract({ abi: starAbi })

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"allowance"`
 */
export const readStarAllowance = /*#__PURE__*/ createReadContract({
  abi: starAbi,
  functionName: 'allowance',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"balanceOf"`
 */
export const readStarBalanceOf = /*#__PURE__*/ createReadContract({
  abi: starAbi,
  functionName: 'balanceOf',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"coords"`
 */
export const readStarCoords = /*#__PURE__*/ createReadContract({
  abi: starAbi,
  functionName: 'coords',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"decimals"`
 */
export const readStarDecimals = /*#__PURE__*/ createReadContract({
  abi: starAbi,
  functionName: 'decimals',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"galaxy"`
 */
export const readStarGalaxy = /*#__PURE__*/ createReadContract({
  abi: starAbi,
  functionName: 'galaxy',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"name"`
 */
export const readStarName = /*#__PURE__*/ createReadContract({
  abi: starAbi,
  functionName: 'name',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"symbol"`
 */
export const readStarSymbol = /*#__PURE__*/ createReadContract({
  abi: starAbi,
  functionName: 'symbol',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"totalSupply"`
 */
export const readStarTotalSupply = /*#__PURE__*/ createReadContract({
  abi: starAbi,
  functionName: 'totalSupply',
})

/**
 * Wraps __{@link readContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"transfersEnabled"`
 */
export const readStarTransfersEnabled = /*#__PURE__*/ createReadContract({
  abi: starAbi,
  functionName: 'transfersEnabled',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link starAbi}__
 */
export const writeStar = /*#__PURE__*/ createWriteContract({ abi: starAbi })

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"approve"`
 */
export const writeStarApprove = /*#__PURE__*/ createWriteContract({
  abi: starAbi,
  functionName: 'approve',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"enableTransfers"`
 */
export const writeStarEnableTransfers = /*#__PURE__*/ createWriteContract({
  abi: starAbi,
  functionName: 'enableTransfers',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"mint"`
 */
export const writeStarMint = /*#__PURE__*/ createWriteContract({
  abi: starAbi,
  functionName: 'mint',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"setPosition"`
 */
export const writeStarSetPosition = /*#__PURE__*/ createWriteContract({
  abi: starAbi,
  functionName: 'setPosition',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"transfer"`
 */
export const writeStarTransfer = /*#__PURE__*/ createWriteContract({
  abi: starAbi,
  functionName: 'transfer',
})

/**
 * Wraps __{@link writeContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"transferFrom"`
 */
export const writeStarTransferFrom = /*#__PURE__*/ createWriteContract({
  abi: starAbi,
  functionName: 'transferFrom',
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link starAbi}__
 */
export const simulateStar = /*#__PURE__*/ createSimulateContract({
  abi: starAbi,
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"approve"`
 */
export const simulateStarApprove = /*#__PURE__*/ createSimulateContract({
  abi: starAbi,
  functionName: 'approve',
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"enableTransfers"`
 */
export const simulateStarEnableTransfers = /*#__PURE__*/ createSimulateContract(
  { abi: starAbi, functionName: 'enableTransfers' },
)

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"mint"`
 */
export const simulateStarMint = /*#__PURE__*/ createSimulateContract({
  abi: starAbi,
  functionName: 'mint',
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"setPosition"`
 */
export const simulateStarSetPosition = /*#__PURE__*/ createSimulateContract({
  abi: starAbi,
  functionName: 'setPosition',
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"transfer"`
 */
export const simulateStarTransfer = /*#__PURE__*/ createSimulateContract({
  abi: starAbi,
  functionName: 'transfer',
})

/**
 * Wraps __{@link simulateContract}__ with `abi` set to __{@link starAbi}__ and `functionName` set to `"transferFrom"`
 */
export const simulateStarTransferFrom = /*#__PURE__*/ createSimulateContract({
  abi: starAbi,
  functionName: 'transferFrom',
})

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link starAbi}__
 */
export const watchStarEvent = /*#__PURE__*/ createWatchContractEvent({
  abi: starAbi,
})

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link starAbi}__ and `eventName` set to `"Approval"`
 */
export const watchStarApprovalEvent = /*#__PURE__*/ createWatchContractEvent({
  abi: starAbi,
  eventName: 'Approval',
})

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link starAbi}__ and `eventName` set to `"PositionSet"`
 */
export const watchStarPositionSetEvent = /*#__PURE__*/ createWatchContractEvent(
  { abi: starAbi, eventName: 'PositionSet' },
)

/**
 * Wraps __{@link watchContractEvent}__ with `abi` set to __{@link starAbi}__ and `eventName` set to `"Transfer"`
 */
export const watchStarTransferEvent = /*#__PURE__*/ createWatchContractEvent({
  abi: starAbi,
  eventName: 'Transfer',
})
