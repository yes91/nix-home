{ lib, pkgs, ...}:

let
  wallpaper = pkgs.copyPathToStore ~/.config/nixpkgs/cfg/art/cyberpunk.jpg;
in {
  xresources = {
    extraConfig = ''
      !   Not even sure what these do    
  
      *border_active: #bedddc
      *border_edge: #ccbf92
    
      !   Colors I guess

      ! black
      *.color0:       #1d1b18
      *.color8:       #48433e

      ! red
      *.color1:       #fbae9f
      *.color9:       #fa4c39

      ! green
      *.color2:       #bfc267
      *.color10:      #c2c219

      ! yellow
      *.color3:       #ddb26f
      *.color11:      #de9116

      ! blue
      *.color4:       #a8dbf0
      *.color12:      #60e6f0

      ! magenta
      *.color5:       #cca3ee
      *.color13:      #c55fed

      ! cyan
      *.color6:       #51cfaf
      *.color14:      #00cf8e

      ! white
      *.color7:       #aba289
      *.color15:      #ffeabf
    '';
  };

  xsession = {
    enable = true;

    windowManager.i3 = rec {
      enable = true;
      package = pkgs.i3-gaps;

      config = {

        gaps = {
          inner = 10;
          outer = 10;
        };

        bars = [];

        modifier = "Mod4";

        keybindings = let mod = config.modifier; in lib.mkOptionDefault {
          "${mod}+d" = "exec rofi -show run";
        };      
      };

      extraConfig = ''
        for_window [class="^.*"] border pixel 0

        exec_always --no-startup-id ${pkgs.feh}/bin/feh --bg-scale ${wallpaper}
        exec_always --no-startup-id systemctl --user restart polybar
      '';
    };
  };
}
