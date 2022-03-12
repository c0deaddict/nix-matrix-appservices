{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-syncproxy-bin";
  version = "unstable-2021-08-31";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "syncproxy";
    rev = "808118c0daa684f3d82f28efc6b6d8ef70e1a4af";
    sha256 = "sha256-CDzeJm0hTErLQwcPAvsnCYT2LZlv7iAXHmdMF9ZiK8Y=";
  };

  vendorSha256 = "sha256-ni1fcNNeaTBkfwNFztzmEAgA0v5a6sWoo93CvHQkvVA=";

  doCheck = false;

  proxyVendor = true;

  postInstall = ''
    mv $out/bin/mautrix-syncproxy $out/bin/mautrix-syncproxy-bin
  '';

  meta = with lib; {
    homepage = "https://github.com/mautrix/syncproxy";
    description = "A /sync proxy for encrypted Matrix appservices.";
    mainProgram = "mautrix-syncproxy-bin";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
