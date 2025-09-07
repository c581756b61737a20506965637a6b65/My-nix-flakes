# disko.nix
{ pkgs, lib, ... }:

{
  disko.enableConfig = true;

  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          btrfs = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = null;
              subvolumes = {
                root = { mountpoint = "/"; };
                persist = { mountpoint = "/persist"; };
                nix = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
                home = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}

