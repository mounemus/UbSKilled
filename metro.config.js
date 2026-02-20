const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

const config = getDefaultConfig(__dirname);

// Add resolver for path aliases
config.resolver.extraNodeModules = {
  '@': path.resolve(__dirname),
};

// Add source extensions
config.resolver.sourceExts = [...config.resolver.sourceExts, 'mjs', 'cjs'];

module.exports = config;
