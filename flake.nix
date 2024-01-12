{ /*  Canonical example https://github.com/LongerHV/nixos-configuration/blob/master/flake.nix */
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      dubedary = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./nixos/dubedary/configuration.nix ]; # if folder only given will use default.nix in that directory
      };
    };
  };
}
