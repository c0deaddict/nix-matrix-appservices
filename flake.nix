{
  inputs = {
    fup.url = "github:divnix/flake-utils-plus";
    devshell.url = "github:numtide/devshell";
    nixpkgs.url = "github:NixOS/nixpkgs/release-21.11";
  };

  outputs = inputs@{ self, nixpkgs, fup, devshell }:
    fup.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];

      nixosModules.matrix-appservices = import ./module;
      nixosModule = self.nixosModules.matrix-appservices;

      overlays.matrix-appservices = import ./pkgs;
      overlay = self.overlays.matrix-appservices;

      sharedOverlays = [
        self.overlay
        devshell.overlay
      ];

      channels.pkgs.input = nixpkgs;

      outputsBuilder = { pkgs }: {
        packages = {
          inherit (pkgs)
            mx-puppet-groupme
            mx-puppet-slack

            mautrix-twitter
            mautrix-instagram
            ;
        };
        checks.matrix-appservices = import ./test.nix { inherit pkgs; }; 
      };
    };
}
