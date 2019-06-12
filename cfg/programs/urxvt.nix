{...}:

let
  colors = import ~/.config/nixpkgs/colors.nix;
in with colors; {
  programs.urxvt = {
    enable = true;
    scroll.bar.enable = false;
    shading = trans;
    fonts = [ "xft:Source Code Pro:size=10" ];
    extraConfig = {
      "perl-ext-common" = "default,clipboard,config-reload";
      "foreground" = fg;
      "background" = bg;
    };
  };
}
