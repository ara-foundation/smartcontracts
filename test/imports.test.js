/**
 * Test file to verify that ABIs can be imported without module resolution issues
 * This simulates how other applications would import from this package
 */

import { 
  allStarsAbi, 
  starAbi, 
  proxyWrapperAbi,
  allStarsAddress,
  allStarsConfig,
  readAllStars,
  writeAllStars,
  readStar,
  writeStar
} from '../abis.ts';

// Test that ABIs are arrays with expected structure
function testAbiStructure(abi, name) {
  if (!Array.isArray(abi)) {
    throw new Error(`${name} is not an array`);
  }
  
  if (abi.length === 0) {
    throw new Error(`${name} is empty`);
  }
  
  // Check that it has at least one function, event, or error
  const hasValidEntry = abi.some(item => 
    item.type === 'function' || 
    item.type === 'event' || 
    item.type === 'error' ||
    item.type === 'constructor'
  );
  
  if (!hasValidEntry) {
    throw new Error(`${name} does not contain valid ABI entries`);
  }
  
  return true;
}

// Test that addresses are valid format
function testAddress(addressObj, name) {
  if (typeof addressObj !== 'object' || addressObj === null) {
    throw new Error(`${name} is not an object`);
  }
  
  // Check that it has at least one chain ID
  const chainIds = Object.keys(addressObj);
  if (chainIds.length === 0) {
    throw new Error(`${name} has no chain IDs`);
  }
  
  // Validate address format (starts with 0x and is 42 chars)
  for (const [chainId, address] of Object.entries(addressObj)) {
    if (typeof address !== 'string') {
      throw new Error(`${name}[${chainId}] is not a string`);
    }
    if (!/^0x[a-fA-F0-9]{40}$/.test(address)) {
      throw new Error(`${name}[${chainId}] is not a valid Ethereum address: ${address}`);
    }
  }
  
  return true;
}

// Test that config objects have correct structure
function testConfig(config, name) {
  if (typeof config !== 'object' || config === null) {
    throw new Error(`${name} is not an object`);
  }
  
  if (!config.address) {
    throw new Error(`${name} is missing address property`);
  }
  
  if (!config.abi) {
    throw new Error(`${name} is missing abi property`);
  }
  
  return true;
}

// Run all tests
console.log('Testing ABI imports...\n');

try {
  // Test AllStars ABI
  console.log('✓ Testing allStarsAbi...');
  testAbiStructure(allStarsAbi, 'allStarsAbi');
  console.log(`  - Contains ${allStarsAbi.length} entries`);
  
  // Test Star ABI
  console.log('✓ Testing starAbi...');
  testAbiStructure(starAbi, 'starAbi');
  console.log(`  - Contains ${starAbi.length} entries`);
  
  // Test ProxyWrapper ABI
  console.log('✓ Testing proxyWrapperAbi...');
  testAbiStructure(proxyWrapperAbi, 'proxyWrapperAbi');
  console.log(`  - Contains ${proxyWrapperAbi.length} entries`);
  
  // Test address
  console.log('✓ Testing allStarsAddress...');
  testAddress(allStarsAddress, 'allStarsAddress');
  console.log(`  - Contains addresses for chains: ${Object.keys(allStarsAddress).join(', ')}`);
  
  // Test config
  console.log('✓ Testing allStarsConfig...');
  testConfig(allStarsConfig, 'allStarsConfig');
  console.log('  - Config structure is valid');
  
  // Test that helper functions exist and are functions
  console.log('✓ Testing helper functions...');
  if (typeof readAllStars !== 'function') {
    throw new Error('readAllStars is not a function');
  }
  if (typeof writeAllStars !== 'function') {
    throw new Error('writeAllStars is not a function');
  }
  if (typeof readStar !== 'function') {
    throw new Error('readStar is not a function');
  }
  if (typeof writeStar !== 'function') {
    throw new Error('writeStar is not a function');
  }
  console.log('  - All helper functions are available');
  
  // Test that ABIs contain expected functions
  console.log('✓ Testing ABI content...');
  const allStarsFunctions = allStarsAbi
    .filter(item => item.type === 'function')
    .map(item => item.name)
    .filter(Boolean);
  
  const expectedFunctions = ['addGalaxy', 'solarForge', 'spaceCoord', 'galaxies'];
  const hasExpectedFunctions = expectedFunctions.every(fn => 
    allStarsFunctions.includes(fn)
  );
  
  if (!hasExpectedFunctions) {
    throw new Error(`allStarsAbi missing expected functions. Found: ${allStarsFunctions.join(', ')}`);
  }
  console.log(`  - Contains expected functions: ${expectedFunctions.join(', ')}`);
  
  const starFunctions = starAbi
    .filter(item => item.type === 'function')
    .map(item => item.name)
    .filter(Boolean);
  
  const expectedStarFunctions = ['mint', 'transfer', 'balanceOf', 'setPosition'];
  const hasExpectedStarFunctions = expectedStarFunctions.every(fn => 
    starFunctions.includes(fn)
  );
  
  if (!hasExpectedStarFunctions) {
    throw new Error(`starAbi missing expected functions. Found: ${starFunctions.join(', ')}`);
  }
  console.log(`  - Contains expected functions: ${expectedStarFunctions.join(', ')}`);
  
  console.log('\n✅ All tests passed! ABIs can be imported successfully.');
  console.log('\nPackage is ready for use as a library.');
  process.exit(0);
  
} catch (error) {
  console.error('\n❌ Test failed:', error.message);
  console.error(error.stack);
  process.exit(1);
}

