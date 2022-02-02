{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-wsproxy-bin";
  version = "unstable-2021-09-07";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "wsproxy";
    rev = "2f097e3f2b6d003b3c913933839f12a8cd9d2d41";
    sha256 = "0sy7ns60nzq58j500cswvj04q75ji18cnn01bacdrqwnklmh2g24";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-kJw3w14RQBAdMoFItjT/LmzuKaDTR09mW3H+7gNUS3s=";

  doCheck = false;

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/mautrix-wsproxy $out/bin/mautrix-wsproxy-bin

  '';

  meta = with lib; {
    homepage = "https://github.com/mautrix/wsproxy";
    description = "A simple HTTP push -> websocket proxy for Matrix appservices.";
    mainProgram = "mautrix-wsproxy-bin";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ pacman99 ];
  };
}
