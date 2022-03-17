{ config, lib, pkgs, ... }:

{
  services.matrix-appservices = {
    addRegistrationFiles = true;

    services = {
      discord = {
        port = 29180;
        format = "mx-puppet";
        package = pkgs.mx-puppet-discord;
        settings.bridge.enableGroupSync = true;
      };
      groupme = {
        port = 29181;
        format = "mx-puppet";
        package = pkgs.mx-puppet-groupme;
      };
      slack = {
        port = 29182;
        format = "mx-puppet";
        package = pkgs.mx-puppet-slack;
      };
    };
  };
}
