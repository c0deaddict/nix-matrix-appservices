#! nix-shell -i bash -p nodePackages.node2nix

# No official release
rev="695f97c3ab834403489bb01517d433498118e482"
u="https://gitlab.com/robintown/mx-puppet-groupme/-/raw/$rev"
# Download package.json and package-lock.json
# curl -o package.json "$u/package.json?inline=false"
curl -o package-lock.json "$u/package-lock.json?inline=false"

node2nix \
  --nodejs-12 \
  --node-env node-env.nix \
  --input package.json \
  --lock package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix
