{ stdenv, fetchFromGitLab, pkgs, lib, nodejs, nodePackages, pkg-config, libjpeg
, pixman, cairo, pango }:

let
  # No official version ever released
  src = fetchFromGitLab {
    owner = "robintown";
    repo = "mx-puppet-groupme";
    rev = "695f97c3ab834403489bb01517d433498118e482";
    sha256 = "sha256-GPCI1eELNmijBTCdSUi0tnW0XWDPsTCZhEQud5cMBII=";
  };

  myNodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

in myNodePackages.package.override {
  pname = "mx-puppet-groupme";

  inherit src;
  nativeBuildInputs = [ nodePackages.node-pre-gyp pkg-config ];
  buildInputs = [ nodePackages.typescript libjpeg pixman cairo pango ];

  postInstall = ''
    # Patch shebangs in node_modules, otherwise the webpack build fails with interpreter problems
    patchShebangs --build "$out/lib/node_modules/mx-puppet-groupme/node_modules/"
    # compile Typescript sources
    npm run build
    # Make an executable to run the server
    mkdir -p $out/bin
    cat <<EOF > $out/bin/mx-puppet-groupme
    #!/bin/sh
    exec ${nodejs}/bin/node $out/lib/node_modules/mx-puppet-groupme/build/index.js "\$@"
    EOF
    chmod +x $out/bin/mx-puppet-groupme
  '';

  meta = with lib; {
    description = "A puppeting Matrix bridge for GroupMe built with mx-puppet-bridge";
    license = licenses.asl20;
    homepage = "https://gitlab.com/robintown/mx-puppet-groupme";
    maintainers = with maintainers; [ pacman99 ];
    platforms = platforms.unix;
  };
}
