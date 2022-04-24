{ config, lib, pkgs, ... }:

{
  # Mautrix-signal settings
  services.signald.enable = true;
  systemd.services.matrix-as-signal.requires = [ "signald.service" ];
  systemd.services.matrix-as-signal.after = [ "signald.service" ];

  services.matrix-appservices = {
    addRegistrationFiles = true;
    services = {
      whatsapp = {
        port = 29183;
        format = "mautrix-go";
        package = pkgs.mautrix-whatsapp;
      };

      discord = {
        port = 29188;
        format = "mautrix-go";
        package = pkgs.mautrix-discord;
      };

      signal = {
        port = 29184;
        format = "mautrix-python";
        package = pkgs.mautrix-signal;
        serviceConfig = {
          StateDirectory = [ "matrix-as-signal" "signald" ];
          JoinNamespaceOf = "signald.service";
          SupplementaryGroups = [ "signald" ];
        };
        settings.signal = {
          socket_path = config.services.signald.socketPath;
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
