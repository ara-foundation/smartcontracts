# Ara SmartContracts
Representing open-source projects as galaxies, while users as stars.

### What is Ara?
In Ara, every open-source project is called a galaxy. Once the user's issue is resolved, galaxy distributes the stars to the user, maintainer and contributor. Your goal as the project community is to gather as much stars as possible. Once, star amount exceeds a certain threshold, open-source project in Ara changes it's owner to the star owners: users, collaborators along with the maintainers.

To learn more, and what benefit it has for open-source projects Check the website: https://ara.foundation/

## Getting Started

Install the package:

```bash
npm install @ara-web/smartcontracts
```

### Using the Contract ABIs

Import the deployed contract ABIs and types in your application:

```typescript
import { allStarsAbi } from '@ara-web/smartcontracts/deployed';
```

### Use Cases

#### 1. Reading Contract Data

```typescript
import { createReadContract } from '@wagmi/core';
import { allStarsAbi } from '@ara-web/smartcontracts/deployed';
import { baseSepolia } from 'wagmi/chains';

// Read galaxy data
const galaxyData = await createReadContract({
  address: '0x70b089840FB3D567C5d618b222503d68A8ad0dAa',
  abi: allStarsAbi,
  functionName: 'galaxies',
  args: [galaxyId],
  chainId: baseSepolia.id,
});
```

#### 2. Writing to Contracts

```typescript
import { createWriteContract } from '@wagmi/core';
import { allStarsAbi } from '@ara-web/smartcontracts/deployed';

// Add a new galaxy (backend only)
await createWriteContract({
  address: '0x70b089840FB3D567C5d618b222503d68A8ad0dAa',
  abi: allStarsAbi,
  functionName: 'addGalaxy',
  args: [/* galaxy parameters */],
});
```

#### 3. Listening to Events

```typescript
import { createWatchContractEvent } from '@wagmi/core';
import { allStarsAbi } from '@ara-web/smartcontracts/deployed';

// Watch for new galaxies
createWatchContractEvent({
  address: '0x70b089840FB3D567C5d618b222503d68A8ad0dAa',
  abi: allStarsAbi,
  eventName: 'GalaxyAdded',
  onLogs(logs) {
    console.log('New galaxy added:', logs);
  },
});
```

#### 4. With React and wagmi

```typescript
import { useReadContract, useWriteContract } from 'wagmi';
import { allStarsAbi } from '@ara-web/smartcontracts/deployed';

function GalaxyInfo({ galaxyId }: { galaxyId: number }) {
  const { data: galaxy } = useReadContract({
    address: '0x70b089840FB3D567C5d618b222503d68A8ad0dAa',
    abi: allStarsAbi,
    functionName: 'galaxies',
    args: [galaxyId],
  });

  return <div>{galaxy?.name}</div>;
}
```

---

## Deployed Contracts

### Base Sepolia Network

Smartcontracts to track on blockchain explorers:
- Etherscan: [All Stars](https://sepolia.basescan.org/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)
- Blockscout: [All Stars](https://base-sepolia.blockscout.com/address/0x70b089840FB3D567C5d618b222503d68A8ad0dAa#code)
- Sourcify: [All Stars](https://sourcify.dev/server/repo-ui/84532/0x70b089840FB3D567C5d618b222503d68A8ad0dAa)

---

## For Contributors

### Deploy

Firstly, set the `.env` based on `.env.example`.

Then deploy the smartcontracts:

```shell
npx hardhat run ./scripts/deploy-all-stars.js --network [network_name]
```

Then verify the smartcontracts:

```shell
npx hardhat verify --network [network_name] [deployed_contract_address]
```

### Generating ABIs

To regenerate the ABIs after contract changes:

1. Add the addresses and network in `/wagmi.config.ts`
2. Run `npm run wagmi` to re-generate the abi files
3. The updated `./abis.ts` will be ready for publishing