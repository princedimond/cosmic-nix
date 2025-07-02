{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # NOTE: change "unstable" to "24.05" if you are using NixOS 24.05
    nixvim.url = "github:dc-tec/nixvim";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
     cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
     home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      cosmic-manager,
      home-manager,
      nixvim,
      zen-browser,
      nix-flatpak,
    }:
    {
    packages.x86_64-linux.evil-helix = import ./evil-helix.nix {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      };

    packages.x86_64-linux.crd = import ./crd.nix {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      };
      nixosConfigurations = {
        # NOTE: change "host" to your system's hostname
        PD-JMP7YY2 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
          #  {
           #   nix.settings = {
            #    substituters = [ "https://cosmic.cachix.org/" ];
             #   trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
             # };
            #}
           # nixos-cosmic.nixosModules.default
             nix-flatpak.nixosModules.nix-flatpak
            ./configuration.nix
          ];
        };
      };
    };
}
