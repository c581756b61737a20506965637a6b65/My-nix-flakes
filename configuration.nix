{ config, pkgs, lib, specialArgs, ... }:

{
  imports = [ ];

  system.stateVersion = "23.11";

  # EFI bootloader setup
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Secure and boot-critical mount for /persist
  fileSystems."/persist" = {
    device = "zroot/local/persist";
    fsType = "zfs";
    neededForBoot = true;
    options = [ "noatime" "nodev" "nosuid" ];
  };

  # Impermanence: persist only essential state
  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"        # Your system config
      "/var/lib"          # Application and system state
      "/var/log"          # Logs
    ];
    files = [
      "/etc/machine-id"   # Required for networking and D-Bus
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  # Recreate non-persistent dirs on each boot
  systemd.tmpfiles.rules = [
    "d /var/lib 0755 root root - -"
    "d /var/log 0755 root root - -"
  ];

  # Optional: auto-login (for testing) or hostname
  networking.hostName = specialArgs.hostname;

  # Standard NixOS stuff
  time.timeZone = "DK";

  services.openssh.enable = true;

  users.users.${specialArgs.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Use ZFS native support (in case it's not already)
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.enableUnstable = true;  # Needed for newer features sometimes

  services.zfs.trim.enable = true;
  services.zfs.trim.interval = "weekly";  # or "daily"

  programs.nh = {
  enable = true;
  flake = "/etc/nixos";  # or wherever your flake is
};

}
