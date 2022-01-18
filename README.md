# Universal NixOS module for Matrix appservices
Use this flake to easily setup matrix appservices on a nixos server.

You no longer have to think about generating registration files or
configuring docker or systemd to run the appservices.

This module can take care of the heavy lifting, so you only have to
think about the important settings that the appservice needs.

## Usage
Once you have imported the module(see next section), you can spin
up most appservices with just a few lines of nixos configuration.

For example, here is how you would setup mautrix-whatsapp:
```
{ pkgs, ... }:
{
  services.matrix-appservices = {
    whatsapp = {
      port = 29183;
      format = "mautrix-go";
      package = pkgs.mautrix-whatsapp;
    };
  };
}
```

There you go! Once you rebuild, mautrix-whatsapp will be running
as a systemd service named `matrix-as-whatsapp` and all its data will
be stored in `/var/lib/matrix-as-whatsapp`.

If you would like the module to configure synapse or dendrite to
include all appservice registration files you can just set:
`services.matrix-appservices.addRegistrationFiles = true`.

## Configuring
There are many options available to configure the way each appservice
is setup. But to consolidate similarities, there are three formats
available which set sane defaults for those options: `mautrix-go`,
`mautrix-python`, and `mx-puppet`.

For the majority of appservices meant for personal use, you likely
will only have to set a `port`, `format`, and `package`. And if the
appservice is more complicated you can take advantage of the other
options to 

In the preStart script of each appservice, a registration file is automatically
generated with random strings for the important tokens and any data passed
to the `registrationData` option. This file will be available to your `settings`
and `startupScript` as `$REGISTRATION_FILE`.

After this, a configuration file is generated based on the `settings` passed
to the appservice. Environment variables are also substuted in with envsubst,
so the `serviceConfig.EnvironmentFile` option can be used to pass secrets for the appservice.

### Environment Variables
These variables are available in your `startupScript` and `settings`(substituted in):
 - $REGISTRATION_FILE => The registration file generated automatically
 - $SETTINGS_FILE => Settings file generated
 - $DIR => Data directory of the appservice
 - $AS_TOKEN => Appservice token(needs to be kept secret)
 - $HS_TOKEN => Homeserver token(needs to be kept secret)
 - Anything else in `serviceConfig.EnvironmentFile`

## Importing the module
### With Flakes
Add this flake as an input, then import the `nixosModule` output in
your configuration.
```
{
  inputs.nix-matrix-appservices.url = "gitlab:coffeetables/nix-matrix-appservices";

  outputs = { self, nixpkgs, nix-matrix-appservices }: {
    # change `yourhostname` to your actual hostname
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      # change to your system:
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        nix-matrix-appservices.nixosModule
      ];
    };
  };
}
```
Or if you use digga/devos or flake-utils-plus, you could pass the module
to the `hostDefaults.modules` argument, which is under the `nixos` category in digga.

### Without Flakes(legacy)
In your `configuration.nix` or any other profile/module:
```
{ pkgs, ... }:
let
  nix-matrix-appservices = fetchTarball
    "https://gitlab.com/coffeetables/nix-matrix-appservices/-/archive/master/myrdd-master.tar.gz";
{
  imports = [
    "${nix-matrix-appservices}/module" 
  ];
}
```

## TODO
 - [ ] Generate docs for options
 - [ ] Re-package matrix-appservices even ones in nixpkgs, so I can export packages
       that I know work with the module
 - [ ] Improve test to message the bot and check for a response to ensure registration was
       done right
 - [ ] Test more appservices(right now only discord is being tested)
