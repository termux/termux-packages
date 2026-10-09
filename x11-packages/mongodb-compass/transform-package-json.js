'use strict';
const fs = require('fs');
const path = require('path');

const pkgDir = 'packages/compass';
const pkg = JSON.parse(fs.readFileSync(path.join(pkgDir, 'package.json'), 'utf8'));

for (const key of ['devDependencies', 'dependency-check', 'repository', 'check']) {
  delete pkg[key];
}
delete pkg.config.hadron.build;
delete pkg.scripts.install;

// pin to versions resolved in the monorepo
for (const type of ['dependencies', 'peerDependencies', 'optionalDependencies']) {
  for (const name of Object.keys(pkg[type] || {})) {
    for (const base of [path.join(pkgDir, 'node_modules'), 'node_modules']) {
      const file = path.join(base, name, 'package.json');
      if (fs.existsSync(file)) {
        pkg[type][name] = JSON.parse(fs.readFileSync(file, 'utf8')).version;
        break;
      }
    }
  }
}

Object.assign(pkg, {
  channel: 'stable',
  distribution: 'compass',
  productName: 'MongoDB Compass',
});
pkg.config.hadron.distributions.compass.productName = 'MongoDB Compass';

fs.writeFileSync(process.argv[2], JSON.stringify(pkg, null, 2));
