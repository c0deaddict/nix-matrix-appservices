#!/usr/bin/env bash


#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

# No official release
rev=691e53d2d703bd169e1f23a8d8dff3f008d8c4ef
u=https://raw.githubusercontent.com/Sorunome/mx-puppet-slack/$rev
# Download package.json and package-lock.json
curl -O $u/package.json
curl -O $u/package-lock.json

node2nix \
  --nodejs-12 \
  --node-env node-env.nix \
  --input package.json \
  --lock package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix

sed -i 's|<nixpkgs>|../../..|' node-composition.nix

rm -f package.json package-lock.json
