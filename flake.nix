{
  description = "NixOS config with impermanence, NVF, Stylix, and Hyperland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    impermanence.url = "github:nix-community/impermanence";
    home-manager.url = "github:nix-community/home-manager";

    stylix.url = "github:nix-community/stylix";
    nvf.url = "github:NotAShelf/nvf";
    wayland.url = "github:nix-community/nixpkgs-wayland";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    {
      nixosConfigurations = {
        mySystem = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
            username = "Brak";
            hostname = "I-use-nix-btw";
          };

          modules = [
            ./configuration.nix
            ./hardware-configuration.nix

            inputs.disko.nixosModules.disko
            ./disko-config.nix
            inputs.impermanence.nixosModules.impermanence

            ./System/stylix.nix
            inputs.stylix.nixosModules.stylix
            inputs.nvf.nixosModules.nvf
          ];

          pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ wayland.overlay ];
          };
        };
      };
      homeConfigurations = {
        Brak = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [
            ./Home/stylix.nix
            ./Home/nvf.nix
            ./Home/hyperland.nix
          ];
        };
      };
    };
}
