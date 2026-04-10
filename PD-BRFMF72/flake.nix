{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # NOTE: change "unstable" to "24.05" if you are using NixOS 24.05
    nixvim.url = "github:dc-tec/nixvim";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
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

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      cosmic-manager,
      home-manager,
      zen-browser,
      nixvim,
      nix-flatpak,
      catppuccin,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        # NOTE: change "host" to your system's hostname
        PD-BRFMF72 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            nix-flatpak.nixosModules.nix-flatpak
            # nixos-cosmic.nixosModules.default
            ./configuration.nix
            ./host-apps.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit inputs;
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.princedimond = {
                  imports = [
                   ./home.nix
                   cosmic-manager.homeManagerModules.cosmic-manager
                   inputs.catppuccin.homeModules.catppuccin
                  ];
                };
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };
    };
}
