{ config, pkgs, lib, fetchFromGitHub, ... }:

      {

        home.username = "leons";
        home.homeDirectory = "/home/leons";

        home.stateVersion = "23.05"; # Please read the comment before changing.

        #keyboard config
        home.keyboard.layout = "us";

        # waybar config
        programs.waybar.settings.mainBar.cpu.format = "{icon0} {icon1} {icon2} {icon3}";

        # packages only needed on surface pro 3
        fonts.fontconfig.enable = true;
        home.packages = with pkgs; [
          egl-wayland
          qt6.qtwayland
          libsForQt5.qt5.qtwayland
          (nerdfonts.override { fonts = [ "FiraMono" "FiraCode" ]; })
          noto-fonts

          # (python311.withPackages (p: with p; [
          #   pyqt5
          #   pyqt6
          #   numpy
          #   matplotlib
          #   scipy
          # ]))
         ];

        # sway config
        wayland.windowManager.sway= {
          config = rec {
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

          keybindings = let
            modifier = config.wayland.windowManager.sway.config.modifier;
          in lib.mkOptionDefault {
            "${modifier}+F2"  = "exec brightnessctl set +5%";
            "${modifier}+F1"= "exec brightnessctl set 5%-";
            "${modifier}+n" = "exec sway output eDP-1 transform normal, splith";
            "${modifier}+t" = "exec sway output eDP-1 transform 90, splitv";
          };

          startup = [
            { command = "sleep 60 && nixGL nextcloud --background";}
          ]; 
        };

        extraConfig = "
exec swaymsg input 7062:6917:NTRG0001:01_1B96:1B05 map_to_output eDP-1
exec swaymsg input 7062:6917:NTRG0001:01_1B96:1B05_Stylus map_to_output eDP-1
";   
        };
      }
