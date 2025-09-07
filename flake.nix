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

    nh.url = "github:nix-community/nh";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";

      # Global specialArgs shared by nixosConfigurations and homeConfigurations
      specialArgs = {
        inherit inputs;
        username = "Brak";
        hostname = "I-use-nix-btw";
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ inputs.wayland.overlay ];
      };
    in
    {
      nixosConfigurations = {
        mySystem = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;

          modules = [
            ./configuration.nix
            ./hardware-configuration.nix

            inputs.disko.nixosModules.disko
            ./disko.nix
            inputs.impermanence.nixosModules.impermanence

            ./System/stylix.nix
            inputs.stylix.nixosModules.stylix
            inputs.nvf.nixosModules.nvf
          ];

          inherit pkgs;
        };
      };

      homeConfigurations = {
        ${specialArgs.username} = home-manager.lib.homeManagerConfiguration {
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
