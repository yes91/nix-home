{...}:

let
  colors = import ~/.config/nixpkgs/colors.nix;
in with colors; {
  programs.rofi = {
    enable = true;

    colors = {
      window = {
        background = argb_bg;
        border = clear;
        separator = clear;
      };

      rows = {
      
        normal = {
          background = argb_bg;
          foreground = fg;
          backgroundAlt = argb_bg;
          highlight = {
            background = bg;
            foreground = fg;
          };
        };
        
        active = {
          background = clear;
          foreground = "#0ea1f0";
          backgroundAlt = bg;
          highlight = {
            background = "#0ea1f0";
            foreground = bg;
          };
        };

        urgent = {
          background = "#fdf6e3";
          foreground = "#dc322f";
          backgroundAlt = "#eee8d5";
          highlight = {
            background = "#dc322f";
            foreground = "#fdf6e3";
          };
        };
        
      };
    };
  };
}
