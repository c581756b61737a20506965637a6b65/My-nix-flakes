{ config, pkgs, specialArgs, ... }:

let
  user = specialArgs.username;
in
{
  home.persistence."/persist/home/${user}" = {
    directories = [
      ".config"   # full user config
      ".local/share"
      ".local/state"
      ".cache"    # optionally include or exclude
    ];

    files = [
      ".bash_history"
      ".zsh_history"
    ];
  };
}
