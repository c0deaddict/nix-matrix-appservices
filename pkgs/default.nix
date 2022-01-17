final: prev: {
  mx-puppet-groupme = prev.callPackage ./mx-puppet-groupme { };
  mx-puppet-slack = prev.callPackage ./mx-puppet-slack { };

  mautrix-twitter = prev.callPackage ./mautrix-twitter { };
  mautrix-instagram = prev.callPackage ./mautrix-instagram { };
  mautrix-wsproxy = prev.callPackage ./mautrix-wsproxy { };

  matrix-emailbridge = prev.callPackage ./matrix-emailbridge { };
}
