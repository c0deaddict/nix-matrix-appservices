{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "unstable-2022-09-19";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "6be531685f308f081675034904d89c9e920be996";
    sha256 = "sha256-j/LjX41ajTzUTrwsvLO8fjPCJXwHkSe8P9ClYOj51I4=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-apQSgwzKmPa5B7CbDhSzr7xgusLNCXJ8ww/3IWUZTjU=";

  doCheck = false;

  proxyVendor = true;

  meta = with lib; {
    homepage = "https://github.com/mautrix/discord";
    description = "Matrix <-> Discord hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ pacman99 ];
  };
}
