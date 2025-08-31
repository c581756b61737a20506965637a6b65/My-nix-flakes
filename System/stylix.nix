{ inputs, ... }:

{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    image = "https://source.unsplash.com/random/1920x1080";
    base16Scheme = "gruvbox-dark-soft";
  };
}
