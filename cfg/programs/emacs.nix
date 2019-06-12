{ pkgs, ... }:

let
  theme = pkgs.writeText "doom-cyber-theme" (import ./emacs/themes/doom-cyber-theme.nix {});
in {
  home.file.".emacs.d/init.el".source = ./emacs/init.el;
  home.file.".emacs.d/themes/doom-cyber-theme.el".source = theme;

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [

      # Interface
      projectile
      treemacs
      treemacs-projectile
      all-the-icons
      doom-themes

      # Modes & Tools
      nix-mode
      rainbow-mode
      magit
    ];
  };
}
