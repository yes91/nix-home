{ pkgs, ...}:

let
  colors = import ~/.config/nixpkgs/colors.nix;

  scroller = pkgs.writeScript "scroll" ''
    if ! "${pkgs.mpc_cli}/bin/mpc" >/dev/null 2>&1; then
      echo Server offline
      exit 1
    elif "${pkgs.mpc_cli}/bin/mpc" status | "${pkgs.gnugrep}/bin/grep" -q playing; then
    ( "${pkgs.mpc_cli}/bin/mpc" current | "${pkgs.zscroll}/bin/zscroll" -l 20 -d 0.2 -n ) &
    else
      echo Not playing
    fi
    # Block until an event is emitted
    "${pkgs.mpc_cli}/bin/mpc" idle >/dev/null
  '';

in with colors; {
  services.polybar = {
    enable = true;
    package =
      pkgs.polybar.override {
        i3GapsSupport = true;
        # alsaSupport = true;
        # iwSupport = true;
        mpdSupport = true;
        githubSupport = true;
      };
    config = {
      "bar/top" = {
        width = "100%";
        height = 27;
        radius = 0;
        fixed-center = false;
        background = polybar.background;
        foreground = polybar.foreground;
        line-size = 3;
        line-color = "#f00";
        border-size = 0;
        border-color = "#00000000";
        padding-left = 0;
        padding-right = 0;
        module-margin-left = 0;
        module-margin-right = 1;
        font-0 = "Source Code Pro:size=10";
        font-1 = "Font Awesome:size=12;1";
        font-2 = "xft:DejaVu:size=10;2";
        font-3 = "Symbola:size=12;1";
        font-4 = "Font Awesome 5 Free Solid:size=12;1";
        modules-left = [ "i3" ];
        modules-center = [ "mpd-scroll" "mpd" ];
        modules-right = [
          "filesystem"
          # "backlight-acpi"
          "volume"
          "xkeyboard"
          "memory"
          "cpu"
          # "wlan"
          "eth"
          # "battery"
          "temperature"
          "date"
          "powermenu"
        ];
      };
    };
    script = "polybar top &";
    extraConfig = ''
      [module/xwindow]
      type = internal/xwindow
      label = %title:0:30:...%

      [module/xkeyboard]
      type = internal/xkeyboard
      blacklist-0 = num lock
      format-prefix = " "
      format-prefix-foreground = ${polybar.foreground}
      format-prefix-underline = ${polybar.primary}
      
      label-layout = %layout%
      label-layout-underline = ${polybar.primary}

      label-indicator-padding = 2
      label-indicator-margin = 1
      label-indicator-background = ${polybar.secondary}
      label-indicator-underline = ${polybar.secondary}

      [module/filesystem]
      type = internal/fs
      interval = 25

      format-mounted = " <label-mounted>"

      mount-0 = /
      mount-1 = /home

      label-mounted = %{F#00cccc}%mountpoint%%{F-}: %percentage_used%%
      label-unmounted = %mountpoint% not mounted
      label-unmounted-foreground = ${polybar.foreground}

      [module/i3]
      type = internal/i3

      ws-icon-0 = "1;"
      ws-icon-1 = "2;"
      ws-icon-2 = "3;"
      ws-icon-3 = "4;"
      ws-icon-4 = "5;"
      ws-icon-default = "space"

      format = <label-state> <label-mode>
      index-sort = true
      wrapping-scroll = false

      ; Only show workspaces on the same output as the bar
      pin-workspaces = true
      strip-wsnumbers = true
      fuzzy-match = true

      label-mode-padding = 2
      label-mode-foreground = #000
      label-mode-background = ${polybar.primary}

      ; focused = Active workspace on focused monitor
      label-focused = %icon%
      label-focused-background = ${polybar.foreground}
      label-focused-foreground = ${polybar.background}
      label-focused-underline= ${polybar.primary}
      label-focused-padding = 2

      ; unfocused = Inactive workspace on any monitor
      label-unfocused = %icon%
      label-unfocused-padding = 2

      ; visible = Active workspace on unfocused monitor
      label-visible = %icon%
      label-visible-background = \''${self.label-focused-background}
      label-visible-underline = \''${self.label-focused-underline}
      label-visible-padding = \''${self.label-focused-padding}

      ; urgent = Workspace with urgency hint set
      label-urgent = %icon%
      label-urgent-background = ${polybar.alert}
      label-urgent-padding = 2

      [module/mpd-scroll]
      type = custom/script
      format-prefix = " "
      exec = ${scroller}
      tail = true
      interval = 2

      [module/mpd]
      type = internal/mpd

      format-online = | <icon-prev> <icon-stop> <toggle> <icon-next> | <icon-random> <icon-repeat>

      icon-prev = 
      icon-stop = 
      icon-play = 
      icon-pause = 
      icon-next = 
      icon-random = 
      icon-repeat = 

      label-song-maxlen = 25
      label-song-ellipsis = true

      [module/xbacklight]
      type = internal/xbacklight

      format = <ramp> <bar>

      ramp-0 = 🌕
      ramp-1 = 🌔
      ramp-2 = 🌓
      ramp-3 = 🌒
      ramp-4 = 🌑

      bar-width = 10
      bar-indicator = |
      bar-indicator-foreground = #ff
      bar-indicator-font = 2
      bar-fill = ─
      bar-fill-font = 2
      bar-fill-foreground = ${polybar.primary}
      bar-empty = ─
      bar-empty-font = 2
      bar-empty-foreground = ${polybar.foregroundAlt}

      [module/backlight-acpi]
      inherit = module/xbacklight
      type = internal/backlight
      card = radeon_bl0

      [module/cpu]
      type = internal/cpu
      interval = 2
      format-prefix = " "
      format-prefix-foreground = ${polybar.foreground}
      format-underline = ${polybar.primary}
      label = %percentage%%

      [module/memory]
      type = internal/memory
      interval = 2
      format-prefix = " "
      format-prefix-foreground = ${polybar.foreground}
      format-underline = ${polybar.primary}
      label = %percentage_used%%

      [module/wlan]
      type = internal/network
      interface = wlo1
      interval = 3.0

      format-connected = <ramp-signal> <label-connected>
      format-connected-underline = ${polybar.primary}
      format-connected-background = ${polybar.backgroundAlt}
      label-connected = %essid%

      format-disconnected =
      ;format-disconnected = <label-disconnected>
      ;format-disconnected-underline = \''${self.format-connected-underline}
      ;label-disconnected = %ifname% disconnected
      ;label-disconnected-foreground = ${polybar.foregroundAlt}

      ramp-signal-0 = 
      ramp-signal-foreground = ${polybar.foreground}

      [module/eth]
      type = internal/network
      interface = ens33
      interval = 3.0

      format-connected-underline = ${polybar.primary}
      format-connected-prefix = " "
      format-connected-prefix-foreground = ${polybar.foregroundAlt}
      label-connected = %local_ip%

      format-disconnected =
      ;format-disconnected = <label-disconnected>
      ;format-disconnected-underline = \''${self.format-connected-underline}
      ;label-disconnected = %ifname% disconnected
      ;label-disconnected-foreground = ${polybar.foregroundAlt}

      [module/date]
      type = internal/date
      interval = 5

      date =
      date-alt = "%m-%d-%Y"

      time = %I:%M
      time-alt = %H:%M:%S

      format-prefix = ""
      format-prefix-foreground = ${polybar.foreground}
      format-underline = ${polybar.primary}

      label = %date% %time%
      
      [module/volume]
      type = internal/volume

      format-volume = <ramp-volume> <bar-volume>
      label-volume = VOL
      label-volume-foreground = \''${root.foreground}

      ramp-volume-0 = 
      ramp-volume-1 = 
      ramp-volume-2 = 

      format-muted-prefix = " "
      format-muted-foreground = ${polybar.foregroundAlt}
      label-muted = sound muted

      bar-volume-width = 10
      bar-volume-foreground-0 = ${polybar.primary}
      bar-volume-gradient = false
      bar-volume-indicator = |
      bar-volume-indicator-font = 2
      bar-volume-fill = ─
      bar-volume-fill-font = 2
      bar-volume-empty = ─
      bar-volume-empty-font = 2
      bar-volume-empty-foreground = ${polybar.foregroundAlt}

      [module/battery]
      type = internal/battery
      battery = BAT0
      adapter = AC
      full-at = 98

      format-charging = <animation-charging> <label-charging>
      format-charging-underline = ${polybar.primary}

      format-discharging = <ramp-capacity> <label-discharging>
      format-discharging-underline = \''${self.format-charging-underline}

      format-full-prefix = "✔ "
      format-full-prefix-foreground = ${polybar.foreground}
      format-full-underline = \''${self.format-charging-underline}

      ramp-capacity-0 = 
      ramp-capacity-1 = 
      ramp-capacity-2 = 
      ramp-capacity-3 = 
      ramp-capacity-4 = 
      ramp-capacity-foreground = ${polybar.foreground}

      animation-charging-0 = 
      animation-charging-1 = 
      animation-charging-2 = 
      animation-charging-3 = 
      animation-charging-4 = 
      animation-charging-foreground = ${polybar.foreground}
      animation-charging-framerate = 400

      [module/temperature]
      type = internal/temperature
      thermal-zone = 0
      warn-temperature = 60

      format = <ramp> <label>
      format-underline = ${polybar.primary}
      format-warn = <ramp> <label-warn>
      format-warn-underline = \''${self.format-underline}

      label = %temperature%
      label-warn = %temperature%
      label-warn-foreground = ${polybar.secondary}

      ramp-0 = 
      ramp-1 = 
      ramp-2 = 
      ramp-3 = 
      ramp-4 = 
      ramp-foreground = ${polybar.foreground}

      [module/powermenu]
      type = custom/menu

      format-spacing = 1

      label-open = " "
      label-open-foreground = ${polybar.foreground}
      label-close = cancel
      label-close-foreground = ${polybar.secondary}
      label-separator = |
      label-separator-foreground = ${polybar.foregroundAlt}

      menu-0-0 = reboot
      menu-0-0-exec = menu-open-1
      menu-0-1 = power off
      menu-0-1-exec = menu-open-2

      menu-1-0 = cancel
      menu-1-0-exec = menu-open-0
      menu-1-1 = reboot
      menu-1-1-exec = sudo reboot

      menu-2-0 = power off
      menu-2-0-exec = sudo poweroff
      menu-2-1 = cancel
      menu-2-1-exec = menu-open-0

      [settings]
      screenchange-reload = true
      ;compositing-background = xor
      ;compositing-background = screen
      ;compositing-foreground = source
      ;compositing-border = over

      [global/wm]
      margin-top = 5
      margin-bottom = 5

    '';
  };  
}
