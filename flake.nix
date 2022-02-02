{
  inputs = {
    devshell.url = "github:numtide/devshell";
    nixlib.url = "github:divnix/nixpkgs.lib";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixlib, nixpkgs, devshell, ... }:
    let

      # Unofficial Flakes Roadmap - Polyfills
      # This project is committed to the Unofficial Flakes Roadmap!
      # .. see: https://demo.hedgedoc.org/s/_W6Ve03GK#

      # Super Stupid Flakes (ssf) / System As an Input - Style:
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];

      polyfillOutput = loc: nixlib.lib.genAttrs supportedSystems (system:
        import loc { inherit system inputs; }
      );
    in
    {

      nixosModules.matrix-appservices = import ./module;
      nixosModule = self.nixosModules.matrix-appservices;

      overlays.matrix-appservices = final: prev: import ./pkgs { pkgs = prev; };
      overlay = self.overlays.matrix-appservices;

      packages = polyfillOutput ./packages.nix;

      checks = polyfillOutput ./test.nix;
    };
}
