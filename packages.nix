{ system ? builtins.currentSystem
, inputs ? (import ./.).inputs
}:
import ./pkgs {
  pkgs = inputs.nixpkgs.legacyPackages.${system};
}
