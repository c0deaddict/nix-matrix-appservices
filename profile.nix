{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.matrix-appservices;
  domain = cfg.homeserverDomain;
in
{
  services.signald.enable = true;

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

      whatsapp = {
        port = 29183;
        format = "mautrix-go";
        package = pkgs.mautrix-whatsapp;
      };

      signal = {
        port = 29184;
        format = "mautrix-python";
        package = pkgs.mautrix-signal;
        serviceDependencies = [ "signald.service" ];
        serviceConfig = {
          StateDirectory = [ "matrix-as-signal" "signald" ];
          JoinNamespaceOf = "signald.service";
          SupplementaryGroups = [ "signald" ];
        };
        settings.signal = {
          socket_path = "/run/signald/signald.sock";
          outgoing_attachment_dir = "/var/lib/signald/tmp";
        };
      };

      facebook = {
        port = 29185;
        format = "mautrix-python";
        package = pkgs.mautrix-facebook;
      };

      twitter = {
        port = 29186;
        format = "mautrix-python";
        package = pkgs.mautrix-twitter;
      };

      instagram = {
        port = 29187;
        format = "mautrix-python";
        package = pkgs.mautrix-instagram;
      };
    };
  };
}
