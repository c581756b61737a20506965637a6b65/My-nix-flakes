{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [ ];

  system.stateVersion = "23.11";

  environment.persistence."/persist" = {
    neededForBoot = true;
    directories = [ "/etc/nixos" ];
    files = [ "/etc/machine-id" ];
  };

  environment.persistence."/home" = {
    neededForBoot = true;
    users = {
      "${username}" = {
        directories = [
          "Documents"
          "Games"
          "Programming"
          "Study"
        ];
        files = [ ];
      };
    };
  };

  home-manager.users."${username}".useUserPackages = true;
  home-manager.users."${username}".configuration = import ./Home/stylix.nix;

  environment.systemPackages = with pkgs; [ ];

  services.xserver.enable = false;

  # Some hibernate swap stuff
  # Enable resume support
  boot.initrd.kernelModules = [ "resume" ];

  # Point to swap device
  boot.kernelParams = [ "resume=/dev/nvme0n1p3" ]; # swap partition

  # Recommended systemd sleep settings
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
  '';
}
