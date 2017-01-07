#!/bin/sh -e


# When we publish to npm, the published files are available in the root
# directory, which allows for a clean include or require of sub-modules.
#
#    var language = require('apollo-client/parser');
#

npm run compile

rm -rf ./npm
mkdir ./npm
cd ./lib/src && cp -r ./ ../../npm/ && cd ../
cp apollo.umd.js ../npm/ && cp apollo.umd.js.map ../npm/ && cd ../

# Ensure a vanilla package.json before deploying so other tools do not interpret
# The built output as requiring any further transformation.
node -e "var package = require('./package.json'); \
  delete package.babel; delete package.scripts; delete package.options; \
  package.main = 'apollo.umd.js'; \
  package.module = 'index.js'; \
  package.typings = 'index.d.ts'; \
  var fs = require('fs'); \
  fs.writeFileSync('./npm/version.js', 'exports.version = \"' + package.version + '\"'); \
  fs.writeFileSync('./npm/package.json', JSON.stringify(package, null, 2));"

cp README.md npm/
cp LICENSE npm/
cp .npmignore npm/

# echo 'deploying to npm...'
# cd npm && npm publish
