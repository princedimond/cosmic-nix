{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # NOTE: change "unstable" to "24.05" if you are using NixOS 24.05
    nixvim.url = "github:dc-tec/nixvim";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixos-cosmic, nixvim }: {
    nixosConfigurations = {
      # NOTE: change "host" to your system's hostname
      PD-G4BK722 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          ./configuration.nix
        ];
      };
    };
  };
}
