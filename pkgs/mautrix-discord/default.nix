{ lib, buildGoModule, fetchFromGitLab, olm }:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "unstable-2022-04-22";

  src = fetchFromGitLab {
    owner = "beeper";
    repo = "discord";
    rev = "145c0cc2cbcfeabd13dfbfb8f9b844d2d37a6dcc";
    sha256 = "sha256-FvPYUj6x47JSgBSVvKRrsbOA1WjnEgvYbj+bxpXMyuc=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-WJJHAppvoeG4t7cY6fbuT8HKjYwEmg9PSAqyMcsiKh0=";

  doCheck = false;

  runVend = true;

  meta = with lib; {
    mainProgram = "discord";
    homepage = "https://gitlab.com/beeper/discord";
    description = "Matrix <-> Discord hybrid puppeting/relaybot bridge";
    license = licenses.agpl3;
    maintainers = with maintainers; [ pacman99 ];
  };
}
