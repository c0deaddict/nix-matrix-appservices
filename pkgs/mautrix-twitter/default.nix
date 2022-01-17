{ stdenv
, lib
, python3
, makeWrapper
, fetchFromGitHub
}:

with python3.pkgs;

let
  # officially supported database drivers
  dbDrivers = [
    asyncpg
    # sqlite driver is already shipped with python by default
  ];

in

buildPythonApplication rec {
  pname = "mautrix-twitter";
  version = "unstable-2021-11-12";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "twitter";
    rev = "deae0e10e6e376be2a0d02edcdc70965b46f05a7";
    sha256 = "sha256-tATiqZlOIi+w6GTBdssv6+pvyHacZh+bDVH5kOrr0Js=";
  };

  postPatch = ''
    sed -i -e '/alembic>/d' requirements.txt
  '';
  postFixup = ''
    makeWrapper ${python}/bin/python $out/bin/mautrix-twitter \
      --add-flags "-m mautrix_twitter" \
      --prefix PYTHONPATH : "$(toPythonPath ${mautrix}):$(toPythonPath $out):$PYTHONPATH"
  '';

  propagatedBuildInputs = [
    mautrix
    yarl
    aiohttp
    aiosqlite 
    beautifulsoup4
    sqlalchemy
    CommonMark
    ruamel_yaml
    paho-mqtt
    python_magic
    attrs
    pillow
    qrcode
    phonenumbers
    pycryptodome
    python-olm
    unpaddedbase64
    setuptools
  ] ++ dbDrivers;

  checkInputs = [
    pytest
    pytestrunner
    pytest-mock
    pytest-asyncio
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-twitter";
    description = "A Matrix-Twitter DM puppeting bridge";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
  };

}

