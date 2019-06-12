{ lib, pkgs, ... }:

let
  unstable = import <unstable> {};
in {
  imports =
    [
      ./cfg/programs/git.nix
      ./cfg/programs/emacs.nix
      ./cfg/programs/firefox.nix
      ./cfg/programs/rofi.nix
      ./cfg/programs/urxvt.nix
      ./cfg/services/gpg-agent.nix
      ./cfg/services/compton.nix
      ./cfg/services/polybar.nix
      ./cfg/xsession/xsession.nix
    ];

  home.packages = with pkgs; [
    htop
    fortune
    mpc_cli
    ncmpcpp

    # fonts
    emacs-all-the-icons-fonts
    source-code-pro
    dejavu_fonts
    unstable.font-awesome-ttf
    unstable.font-awesome_5
    symbola
  ];

  programs.home-manager = {
    enable = true;
    path = https://github.com/rycee/home-manager/archive/release-19.03.tar.gz;
  };

}
