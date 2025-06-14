{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # NOTE: change "unstable" to "24.05" if you are using NixOS 24.05
    nixvim.url = "github:dc-tec/nixvim";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

   # nixos-cosmic = {
    #  url = "github:lilyinstarlight/nixos-cosmic";
     # inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      #nixos-cosmic,
      nixvim,
      nix-flatpak,
    }:
    {
      nixosConfigurations = {
        # NOTE: change "host" to your system's hostname
        PD-G4BK722 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            #{
       #       nix.settings = {
        #        substituters = [ "https://cosmic.cachix.org/" ];
         #       trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
          #    };
           # }
            nix-flatpak.nixosModules.nix-flatpak
            # nixos-cosmic.nixosModules.default
            ./configuration.nix
          ];
        };
      };
    };
}
