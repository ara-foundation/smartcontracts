import { defineConfig } from '@wagmi/cli'
import { actions, hardhat } from '@wagmi/cli/plugins'

export default defineConfig({
  out: './abis.ts',
  contracts: [],
  plugins: [
    actions(),
    hardhat({
      project: './',
      artifacts: 'artifacts/contracts',
      include: ['**/*.json'],
      exclude: ['build-info/**', '*.dbg.json', 'artifacts.d.ts'],
      deployments: {
        AllStars: {
          84532: '0x70b089840FB3D567C5d618b222503d68A8ad0dAa',
        },
      },
      commands: {
        clean: 'npx hardhat clean',
        build: 'npx hardhat compile',
        rebuild: 'npx hardhat compile',
      },
    }),
  ],
})
