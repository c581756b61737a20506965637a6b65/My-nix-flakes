{ inputs, ... }:

{
  imports = [ inputs.stylix.homeManagerModules.stylix ];
  stylix.enable = true;
}
