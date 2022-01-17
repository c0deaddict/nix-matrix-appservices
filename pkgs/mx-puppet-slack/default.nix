{ stdenv
, fetchFromGitHub
, pkgs
, lib
, nodejs
, nodePackages
, pkg-config
, libjpeg
, pixman
, cairo
, pango
}:

let
  # No official version ever released
  src = fetchFromGitHub {
    owner = "Sorunome";
    repo = pname;
    rev = "691e53d2d703bd169e1f23a8d8dff3f008d8c4ef";
    sha256 = "sha256-cjRmlVCk6jX+CCQiAc/dcormPLe/BafBJeRHCv6Mu1k=";
  };

  myNodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  pname = "mx-puppet-slack";

in
myNodePackages.package.override {

  inherit src;

  nativeBuildInputs = [ nodePackages.node-pre-gyp pkg-config ];
  buildInputs = [ libjpeg pixman cairo pango ];

  postInstall = ''
    # Patch shebangs in node_modules, otherwise the webpack build fails with interpreter problems
    patchShebangs --build "$out/lib/node_modules/${pname}/node_modules/"
    # compile Typescript sources
    npm run build
    # Make an executable to run the server
    mkdir -p $out/bin
    cat <<EOF > $out/bin/${pname}
    #!/bin/sh
    exec ${nodejs}/bin/node $out/lib/node_modules/${pname}/build/index.js "\$@"
    EOF
    chmod +x $out/bin/${pname}
  '';

  meta = with lib; {
    description = "A slack puppeting bridge for matrix";
    license = licenses.asl20;
    homepage = "https://github.com/Sorunome/mx-puppet-slack";
    maintainers = with maintainers; [ pacman99 ];
    platforms = platforms.unix;
  };
}
