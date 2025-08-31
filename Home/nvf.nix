{
  inputs,
  pkgs,
  config,
  ...
}:

{
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf.enable = true;

  home.packages = with pkgs; [ git ];
}
