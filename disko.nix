# disko.nix
{ disks ? [ "/dev/nvme0n1" ] }:
{
  disko.devices = {
    main = {
      device = disks[0];
      type = "disk";
      content = {
        type = "table";
        format = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          BTRFS = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = null;
              subvolumes = {
                "root" = { mountpoint = "/"; };
                "persist" = { mountpoint = "/persist"; };
                "nix" = { mountpoint = "/nix"; };
                "home" = { mountpoint = "/home"; };
              };
            };
          };
        };
      };
    };
  };

  disko.enableConfig = true;
}
