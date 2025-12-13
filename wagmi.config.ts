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
          84532: '0xf689f76d8f060c7472b1f0b71c191a1605ab3568',
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
