{ config, pkgs, lib, fetchFromGitHub, ... }:

{

  home.username = "leons";
  home.homeDirectory = "/home/leons";

  home.stateVersion = "23.05"; # Please read the comment before changing.

  #keyboard config
  home.keyboard.layout = "us";

  # These packages are used by waybar
  home.packages = with pkgs; [
    playerctl
    pavucontrol
    pamixer
    gnome.gnome-clocks
    wlogout    
    jdiskreport
    monitor
  ];

  # waybar config
  programs.waybar.settings.mainBar.cpu.format = "{icon0} {icon1} {icon2} {icon3}";

  # sway config
  wayland.windowManager.sway.config = rec {
    input = {
      "*" = {
        xkb_layout = "us";
        xkb_options = "grp:win_space_toggle";
        xkb_variant = "altgr-intl";                
      };
      "type:touchpad" = {
        dwt = "enabled";
        tap = "enabled";
        natural_scroll = "enabled";
        middle_emulation = "enabled";
      };
    };

    output = {
      eDP-1 = {
        mode = "2160x1440@59.955Hz";
        scale = "1";
        bg = "~/.dotfiles/wallpaper/surfacewp.png fill";
      };
    };

  };
