{ /*  Canonical example? https://nixos-and-flakes.thiscute.world/nixos-with-flakes/modularize-the-configuration https://github.com/LongerHV/nixos-configuration/blob/master/flake.nix */
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  inputs = {
      myappattribute.url="github:nrbray/mtd-vat-cli/NixOS"; # "git+file:///home/nrb/dir/work/mtd-vat-cli/";
  };
  outputs = { self, nixpkgs, myappattribute }: {
    nixosConfigurations = {
      retsnom = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit myappattribute; };
        modules = [ ./hosts/retsnom/configuration_custom.nix ]; # if folder only given will use default.nix in that directory
      };

      lojijove = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit myappattribute; };
        modules = [ ./hosts/lojijove/configuration.nix ]; # if folder only given will use default.nix in that directory
      };
      dubedary = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit myappattribute; };
        modules = [ ./hosts/dubedary/configuration.nix ]; # if folder only given will use default.nix in that directory
      };
      exemplry = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/exemplry/configuration.nix ]; # if folder only given will use default.nix in that directory
      };
      avingate = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit myappattribute; };
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
        # You need to do:
        specialArgs = { inherit myappattribute; };
        # in your flake.nix (around where you have your `modules`). Otherwise it won't be passed into other modules as args and you are trying to use it there.
        modules = [ ./hosts/mintanin/configuration.nix  ];
    };
      mintanin-old = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/mintanin/configuration-old.nix  ];
    };
    };
  };
}
