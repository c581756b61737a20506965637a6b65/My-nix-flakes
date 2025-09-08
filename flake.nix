{
  description = "NixOS config with impermanence, NVF, Stylix, and Hyperland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
    home-manager.url = "github:nix-community/home-manager";

    stylix.url = "github:nix-community/stylix";
    nvf.url = "github:NotAShelf/nvf";
    wayland.url = "github:nix-community/nixpkgs-wayland";
    nh.url = "github:nix-community/nh";
  };

  outputs = inputs@{ self, nixpkgs, disko, impermanence, home-manager, stylix, nvf, wayland, ... }:
    let
      system = "x86_64-linux";

      specialArgs = {
        inherit self inputs;
        username = "Brak";
        hostname = "I-use-nix-btw";
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ wayland.overlay ];
      };
    in {
      nixosConfigurations = {
        "${specialArgs.hostname}" = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;

          modules = [
            configuration.nix
            hardware-configuration.nix

            disko.nixosModules.disko
            ./disko.nix             # Contains your Disko partitioning config

            impermanence.nixosModules.impermanence

            ./System/stylix.nix
            stylix.nixosModules.stylix
            nvf.nixosModules.nvf
          ];

          inherit pkgs;
        };
      };

      homeConfigurations = {
        "${specialArgs.username}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs specialArgs;
          modules = [
            ./Home/stylix.nix
            ./Home/nvf.nix
            ./Home/hyperland.nix
          ];
        };
      };
    };
}
