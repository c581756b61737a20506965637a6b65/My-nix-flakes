{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";
      input.kb_layout = "us";
      env = [
        "XCURSOR_SIZE,24"
      ];
      exec-once = [
        "hyprpaper"
        "waybar"
      ];
    };
  };

  home.packages = with pkgs; [
    waybar
    hyprpaper
    kitty
  ];

  programs.zsh.enable = true;

  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
}
