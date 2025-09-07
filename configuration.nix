# configuration.nix
{ config, pkgs, lib, specialArgs, ... }:

{
  imports = [ ];

  system.stateVersion = "23.11";

  # Bootloader: systemd-boot for EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Swap file for hibernation
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GiB
    }
  ];

  # File systems mounting Btrfs subvolumes created by Disko
  fileSystems."/" = {
    device = "/dev/disk/by-label/btrfs";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-label/btrfs";
    fsType = "btrfs";
    options = [ "subvol=persist" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/btrfs";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/btrfs";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" ];
  };

  # Impermanence persistence configuration
  environment.persistence."/persist" = {
    neededForBoot = true;
    directories = [ "/etc/nixos" ];
    files = [ "/etc/machine-id" ];
  };

  environment.persistence."/home" = {
    neededForBoot = true;
    users = {
      "${specialArgs.username}" = {
        directories = [ "Documents" "Games" "Programming" "Study" ];
      };
    };
  };

  # Sleep & hibernation kernel and systemd settings
  boot.initrd.kernelModules = [ "resume" ];
  boot.kernelParams = [ "resume=/var/lib/swapfile" ];

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
  '';

  # Disable X server 
  services.xserver.enable = false;
}
