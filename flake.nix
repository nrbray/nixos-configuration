{ /*  Canonical example? https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration https://github.com/LongerHV/nixos-configuration/blob/master/flake.nix */
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      dubedary = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/dubedary/configuration.nix ]; # if folder only given will use default.nix in that directory
      };
      exemplry = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/exemplry/configuration.nix ]; # if folder only given will use default.nix in that directory
      };
      avingate = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/avingate/configuration.nix  ];
    };
      greatbar = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/greatbar/configuration.nix  ];
    };
      mailhost = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/mailhost/configuration.nix  ];
    };
      mailhost-old = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/mailhost/configuration-old.nix  ];
    };
      mintanin = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/mintanin/configuration.nix  ];
    };
      mintanin-old = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/mintanin/configuration-old.nix  ];
    };
    };
  };
}
