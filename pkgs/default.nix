{ pkgs }: {
  mx-puppet-groupme = pkgs.callPackage ./mx-puppet-groupme { };
  mx-puppet-slack = pkgs.callPackage ./mx-puppet-slack { };

  mautrix-twitter = pkgs.callPackage ./mautrix-twitter { };
  mautrix-instagram = pkgs.callPackage ./mautrix-instagram { };
  mautrix-wsproxy = pkgs.callPackage ./mautrix-wsproxy { };
  mautrix-syncproxy = pkgs.callPackage ./mautrix-syncproxy { };
}
