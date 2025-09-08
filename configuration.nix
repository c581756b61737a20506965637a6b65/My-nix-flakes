{ config, pkgs, lib, specialArgs, ... }:

{
  imports = [ ];

  system.stateVersion = "23.11";

  # EFI bootloader setup
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Swapfile for hibernation
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GiB
    }
  ];

  # Mounting Btrfs subvolumes created by Disko via label "nixos"
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=/" "compress=zstd" "noatime" ];
  };
  fileSystems."/persist" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=persist" "compress=zstd" "noatime" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime" ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime" ];
  };

  # Impermanence persistence
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

  # Hibernation setup
  boot.initrd.kernelModules = [ "resume" ];
  boot.kernelParams = [ "resume=/var/lib/swapfile" ];
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
  '';

  # Disable X server (Wayland only)
  services.xserver.enable = false;
}
