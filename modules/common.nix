{ config, pkgs, lib, fetchFromGitHub , ... }:

{

home.packages = with pkgs; [
        git
        firefox
        mako
        wl-clipboard
        wl-mirror
        #keychain
        qalculate-gtk
        obsidian
        syncthing
        nextcloud-client
        spotify
        autotiling
        schildichat-desktop-wayland
        eza
        brightnessctl
        playerctl
        networkmanagerapplet
        discord
        libappindicator-gtk3
        anki-bin
        xdg-desktop-portal 
        grim
        slurp
        mu
        #isync
        gnome.seahorse
        sqlite
        gcr # needed for gnome-secrets to work


    #e: hides scratchpad depending on state, calls emacsclient for edit and then restores the scratchpad state
    #(pkgs.writeShellScriptBin "e" ''
    #bash ~/.config/scripts/hidekitty.sh && emacsclient -c -a nano "$@" && bash ~/.config/scripts/showkitty.sh
    #'')
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

home.file = {
    
  };

home.sessionVariables = {
    EDITOR = "emacsclient -c -a nano";
    SDL_VIDEODRIVER="wayland";
    _JAVA_AWT_WM_NONREPARENTING=1;
    QT_QPA_PLATFORM="wayland";
    XDG_CURRENT_DESKTOP="sway";
    XDG_SESSION_DESKTOP="sway";
    ANKI_WAYLAND="1";
  };

services.mako = {
          enable = true;
          backgroundColor = "#2e3440";
          borderColor = "#88c0d0";
          borderRadius = 15;
          borderSize = 1;
          defaultTimeout = 5000;
          height = 150;
          icons = true;
          ignoreTimeout = true;
          layer = "overlay";
          maxIconSize = 64;
          sort = "-time";
          width = 300;
          font = "monospace 10";
          extraConfig = "[urgency=low]
  border-color=#cccccc
  [urgency=normal]
  border-color=#d08770
  [urgency=high]
  border-color=#bf616a
  default-timeout=0
  [category=mpd]
  default-timeout=2000
  group-by=category
  ";
          };

#  services.gpg-agent = {
#	enable = true;
#	enableSshSupport = true;
#	};

  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets" "ssh"];
  };

  services.mbsync = {
  enable = true;
  };

  services.syncthing = {
        enable = true;
        tray.enable = true;
        #extraOptions = [
        #	"--wait"
        #	];
        };

  services.syncthing.tray.command = "syncthingtray --wait";

  services.blueman-applet.enable = true;

  #services.nextcloud-client = {
        #enable = true;
        #startInBackground = true;
        #};

  services.emacs.enable = true;

programs.home-manager.enable = true;

programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+left" = "no_op";
      "ctrl+shift+right" = "no_op";
      "ctrl+shift+home" = "no_op";
      "ctrl+shift+end" = "no_op";
    };
    theme = "citylights";
  };

programs.wofi = {
	enable = true;
	style = ''window {
margin: 0px;
border: 1px solid #ffd700;
background-color: #282a36;
}

#input {
margin: 5px;
border: none;
color: #f8f8f2;
background-color: #44475a;
}

#inner-box {
margin: 5px;
border: none;
background-color: #282a36;
}

#outer-box {
margin: 5px;
border: none;
background-color: #282a36;
}

#scroll {
margin: 0px;
border: none;
}

#text {
margin: 5px;
border: none;
color: #f8f8f2;
} 

#entry:selected {
background-color: #44475a;
}
		'';
  };

programs.zsh = {
	enable = true;
	shellAliases = {
		ls = "exa -la";
		hg = "history | grep";
		hmswitch = "cd ~/.dotfiles; home-manager --flake .#leons@fedora switch; cd -;"; 
		edithome = "emacsclient -c -a nano ~/.dotfiles/surface/home.nix";
    magit = "emacsclient -nc -e \"(magit-status)\"";
  };
	enableAutosuggestions = true;
	enableCompletion = true;
	autocd = true;
	cdpath = [
		"~/.config"
		];
	defaultKeymap = "emacs";
	dirHashes = {
  		dl    = "$HOME/Downloads";
		};
	history = {
		expireDuplicatesFirst = true;
		path = "~/.histfile";
		save = 10000;
		size = 10000;
		};
	historySubstringSearch.enable = true;
	#syntaxHighlighting.enable = true;
	profileExtra = "eval `keychain --agents ssh --eval id_ed25519`";
	#loginExtra = "bash -l sway";
	#envExtra = "export EDITOR = \"emacsclient -c -a nano\"";  
};

programs.mbsync = {
  enable = true;
  };

  programs.waybar = {
	enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29;
    extraPackages = epkgs: [
        pkgs.mu
    ];   
  };
	
  programs.password-store = {
	enable = true;
	package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
  };

  programs.mu = {
	enable = true;
  };

programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "sway/workspaces" "custom/outer-right-arrow-dark" "sway/window"];
        modules-right = ["custom/outer-left-arrow-dark" "mpris" "custom/left-arrow-light"
                "network"
                "custom/left-arrow-dark"
                "temperature"
                "custom/left-arrow-light"
                "disk"
                "custom/left-arrow-dark"
                "memory"
                "custom/left-arrow-light"
                "cpu"
                "custom/left-arrow-dark"
                "pulseaudio"
                "custom/left-arrow-light"
                "battery"
                "custom/left-arrow-dark"
                "tray"
                "custom/left-arrow-light"
                "clock#2"
                "custom/left-arrow-dark"
                "clock#1" ];
        modules-center = [ "sway/mode" ];
        "sway/mode" = {
                format = "<span style=\"italic\" font-weight=\"bold\">{}</span>";
        };
        #"custom/spotify" = {
        #        exec =  "/usr/bin/python3 ~/.config/waybar/resources/custom_modules/mediaplayer.py --player spotify";
        #        format = "  {}";
        #        return-type = "json";
        #        on-click-right = "playerctl play-pause";
        #	on-click = "exec swaymsg [class=\"Spotify\"] scratchpad show";
        #};

        temperature = {
        #thermal-zone= 2;
        hwmon-path= "/sys/devices/platform/coretemp.0/hwmon/hwmon3/temp3_input";
        critical-threshold = 80;
        format-critical = " {temperatureC}°C";
        format = " {temperatureC}°C";
        #on-click= "grim -g \"$(slurp)\" -t png - | wl-copy -t";

        };

        mpris = {
        #format= "{player_icon} {title} by {artist} ({album}) <small>[{position}/{length}]</small>";
        format= "{player_icon} {title} <small>[{position}/{length}]</small>";
        #format-paused=  "{status_icon} <i>{title} by {artist} ({album}) <small>[{position}/{length}]</small></i>";
        format-paused=  "{status_icon} <i>{title} <small>[{position}/{length}]</small></i>";
        player-icons=  {
                "default" = "▶ ";
                "mpv" = "🎵";
                "spotify" = " ";
        };
        status-icons= {
                "paused"= "⏸ ";
        };
        interval = 1;
        title-len = 20;
        artist-len = 20;
        album-len = 10;
        };
        "custom/left-arrow-dark" = {
                format = "";
                tooltip = false;
        };
        "custom/outer-left-arrow-dark"= {
                format = "";
                tooltip = false;
        };
        "custom/left-arrow-light"= {
                format= "";
                tooltip= false;
        };
        "custom/right-arrow-dark"= {
                format= "";
                tooltip= false;
        };
        "custom/outer-right-arrow-dark"= {
                format= "";
                tooltip= false;
        };
        "custom/right-arrow-light"= {
                format= "";
                tooltip= false;
        };
        "sway/workspaces"= {
                disable-scroll= true;
                format= "{name}";
        };

        "clock#1"= {
                   min-length= 8;
                   interval= 1;
                   format= "{:%H:%M:%S}";
                   on-click-right= "gnome-clocks";
                   tooltip-format= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>\n\nR:Clocks";
        };

        "clock#2"= {
                format= "{:%d. %B %Y}";
                on-click-right= "gnome-clocks";
                tooltip-format= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>\n\nR:Clocks"; 
        };


        pulseaudio= {
                format= "{icon} {volume:2}%";
                format-bluetooth= "{icon} {volume}%";
                format-muted= "MUTE";
                format-icons= {
                        headphones= "";
                        default= [
                                ""
                                ""
                        ];
                };
                scroll-step= 1;
                on-click= "pamixer -t";
                on-click-right= "pavucontrol";
        };
        memory= {
                interval= 5;
                format= " {}%";
                tooltip-format= "Memory: {used:0.1f}G/{total:0.1f}G\nSwap: {swapUsed}G/{swapTotal}G";
                #on-click= "grim -g \"$(slurp)\" -t png - | wl-copy -t";
        };
        cpu= {
                min-length= 6;
                interval= 5;
                #format= handled under SYSTEM SPECIFICS
                format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];		
                #on-click= "grim -g \"$(slurp)\" -t png - | wl-copy -t";
                on-click-right= "com.github.stsdc.monitor";   

        };
        battery= {
                states= {
                        #"good"= 95;
                        "warning"= 60;
                        "error"= 30;
                        "critical"= 15;
                };
                interval=5;	
                format= "{icon} {capacity}%";
                format-charging= "{capacity}% ";
                format-plugged= "{capacity}% ";
                format-icons= [
                        ""
                        ""
                        ""
                        ""
                        ""
                ];
                on-click-right= "wlogout -p layer-shell";
        };
        disk= {
                interval= 30;
                format= "Disk {percentage_used:2}%";
                path= "/";
                #on-click= "grim -g \"$(slurp)\" -t png - | wl-copy -t";
                on-click-right= "jdiskreport";
                states= {
                          "warning"= 80;
                           "critical"= 90;
                };
                tooltip-format = "{used} used out of {total} on {path} ({percentage_used}%)\n{free} free on {path} ({percentage_free}%)";
        };
        tray= {
                icon-size= 20;
        };
        network= {
        interval = 5;
        #interface= "wlp*"; // (Optional) To force the use of this interface
        #format-wifi= "{essid} {signalStrength}% ";
        format-wifi= "{signalStrength}% ";
        #format-ethernet= "{ifname}: {ipaddr}/{cidr} ";
        format-ethernet= "";
        format-linked= "{ifname} (No IP) ";
        format-disconnected= "Disconnected ⚠";
        format-alt= "{ifname}: {ipaddr}/{cidr}";
        tooltip-format-ethernet= "{ifname} via {gwaddr}: {essid} {ipaddr}/{cidr}\n\n⇡{bandwidthUpBytes} ⇣{bandwidthDownBytes}";
        tooltip-format-wifi= "{ifname} via {gwaddr}: {essid} {ipaddr}/{cidr} \n{signaldBm}dBm @ {frequency}MHz\n\n⇡{bandwidthUpBytes} ⇣{bandwidthDownBytes}";
        };
    };
};

    style = ''
@define-color foreground #fdf6e3;
@define-color background #1a1a1a;
@define-color background-alt #292b2e; 
@define-color foreground-warning #268bd2;
@define-color background-warning @background;
@define-color foreground-error red;
@define-color background-error @background;
@define-color foreground-critical gold;
@define-color background-critical blue;


* {
    border: none;
    border-radius: 0;
    font-family: Monospace, "Font Awesome 5 Free";
    font-size: 14px;
    min-height: 0;
    margin: -1px 0px;
}

window#waybar {
        background: transparent;
        color: @foreground;
        transition-duration: .5s;
}

window#waybar.hidden {
    opacity: 0.2;
}


#mpris {
    padding: 0 10px;
    background-color: transparent;
    color: #1DB954;
    font-family: Monospace;
    font-size: 12px;
}

#custom-right-arrow-dark,
#custom-left-arrow-dark {
        color: @background;
        background: @background-alt;
        font-size: 24px;
}

#window {
        font-size: 12px;
        padding: 0 20px;
}

#mode {
    background: @background-critical;
    color: @foreground-critical;
    padding: 0 3px;
}

#custom-outer-right-arrow-dark,
#custom-outer-left-arrow-dark {
        color: @background;
        font-size: 24px;
}

#custom-outer-left-arrow-dark,
#custom-left-arrow-dark,
#custom-left-arrow-light {
        margin: 0 -1px;
}

#custom-right-arrow-light,
#custom-left-arrow-light {
        color: @background-alt;
        background: @background;
        font-size: 24px;
}

#workspaces,
#clock.1,
#clock.2,
#clock.3,
#pulseaudio,
#memory,
#cpu,
#temperature,
#mpris,
#tray {
        background: @background;
}

#network,
#clock.2,
#battery,
#cpu,
#disk {
        background: @background-alt;
}


#workspaces button {
        padding: 0 2px;
        color: #fdf6e3;
}
#workspaces button.focused {
        color: @foreground-warning;
}

#workspaces button:hover {
    background: @foreground;
    color: @background;
        border: @foreground;
        padding: 0 2px;
        box-shadow: inherit;
        text-shadow: inherit;
}

#workspaces button.urgent {
    color: @background-critical;
    background: @foreground-critical;
}

#network {
    color: #cc99c9;
}

#temperature {
    color: #9ec1cf;
}

#disk {
    /*color: #b58900;*/
    color: #9ee09e;
}

#disk.warning {
    color:            @foreground-error;
    background-color: @background-error;
}
#disk.critical,
#temperature.critical {
    color:            @foreground-critical;
    background-color: @background-critical;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}
#pulseaudio.muted {
    color: @foreground-error;
}
#memory {
        /*color: #2aa198;*/
        color: #fdfd97;
}
#cpu {
    /*color: #6c71c4;*/
    color: #feb144;
}

#pulseaudio {
    /*color: #268bd2;*/
    color: #ff6663;
}

#battery {
        color: cyan;
}
#battery.discharging {
    color:      #859900;
}

@keyframes blink {
    to {
        color:            @foreground-error;
        background-color: @background-error;
    }
}

#battery.critical:not(.charging) {
    color:            @foreground-critical;
    background-color: @background-critical;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

#clock.1,
#clock.2,
#clock.3 {
    font-family: Monospace;
}

#clock,
#pulseaudio,
#memory,
#cpu,
#tray,
#temperature,
#network,
#mpris,
#battery,
#disk {
        padding: 0 3px;
}
    '';
  };

wayland.windowManager.sway = {
  enable = true;
  config = rec {
    modifier = "Mod4";
    terminal = "kitty";
    menu = "wofi --show drun -Iib -l 5 -W 500 -x -10 -y -51";
    bars = [{ command = "waybar";}]; 	  
    keybindings = let
      modifier = config.wayland.windowManager.sway.config.modifier;
    in lib.mkOptionDefault {
      "${modifier}+q" = "kill";
      "${modifier}+f" = "exec firefox";
      "${modifier}+e" = "exec emacs";
      "${modifier}+m" = "exec spotify";
      "${modifier}+Shift+d" = "exec wofi --show run -Iib -l 5 -W 500 -x -10 -y -51";
      "${modifier}+n" = "exec sway output eDP-1 transform normal, splith";
      "${modifier}+t" = "exec sway output eDP-1 transform 90, splitv";
      "${modifier}+Shift+F12" = "move scratchpad";
      "${modifier}+F12" = "scratchpad show";
      "${modifier}+p" = "exec wl-mirror eDP-1";
      "${modifier}+c" = "exec qalculate-gtk";
      "${modifier}+x" = "mode $exit";
      "${modifier}+s" = "exec grim -g \"$(slurp)\" -t png - | wl-copy -t image/png";
      "${modifier}+i" = "exec \"bash ~/.dotfiles/scripts/startup.sh\"";
      "${modifier}+1" = "workspace 1:一";
      "${modifier}+Shift+1" = "move container to workspace 1:一";
      "${modifier}+2" = "workspace 2:二";
      "${modifier}+Shift+2" = "move container to workspace 2:二";
      "${modifier}+3" = "workspace 3:三";
      "${modifier}+Shift+3" = "move container to workspace 3:三";
      "${modifier}+4" = "workspace 4:四";
      "${modifier}+Shift+4" = "move container to workspace 4:四";
      "${modifier}+5" = "workspace 5:五";
      "${modifier}+Shift+5" = "move container to workspace 5:五";
      "${modifier}+6" = "workspace 6:六";
      "${modifier}+Shift+6" = "move container to workspace 6:六";
      "${modifier}+7" = "workspace 7:七";
      "${modifier}+Shift+7" = "move container to workspace 7:七";
      "${modifier}+8" = "workspace 8:八";
      "${modifier}+Shift+8" = "move container to workspace 8:八";
      "${modifier}+9" = "workspace 9:九";
      "${modifier}+Shift+9" = "move container to workspace 9:九";
      "${modifier}+0" = "workspace 10:十";
      "${modifier}+Shift+0" = "move container to workspace 10:十";
      "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86MonBrightnessUp"  = "exec brightnessctl set +5%";
      "XF86MonBrightnessDown"= "exec brightnessctl set 5%-";
    };
    modes = {
    };

    startup = [
      #{ command = "systemctl --user restart nextcloud-client"; always = true; }
      #{ command = "systemctl --user restart syncthingtray"; always = true; }
      #{ command = "systemctl --user restart syncthingtray";}
      #{ command = "systemctl --user restart nextcloud-client";}
      #{ command = "firefox"; }
      { command = "exec \"bash ~/.dotfiles/scripts/startup.sh\"";}
    ];
    window = {
      border = 1;
      titlebar = false;
    };
    assigns = {
      #"1" = [{ class = "^Firefox$"; }];
    };
    colors = {
      focused = {
        background = "#080808";
        border = "#80a0ff";
        childBorder = "#80a0ff";
        indicator = "#080808";
        text = "#ffd700";
      };
      unfocused = {
        background = "#080808";
        border = "#80a0ff";
        childBorder = "#303030";
        indicator = "#80a0ff";
        text = "#c6c6c6";
      };
    };
    floating = {
      border = 1;
      criteria = [
        {
          title = "^Picture-in-Picture$";
        }
        {app_id = "qalculate-gtk";}
        {app_id = "org.gnome.clocks";}
        {app_id = "com.github.stsdc.monitor";}
        {app_id = "python3";}
        {app_id = "blueman";}
        {app_id = "pavucontrol";}
        {app_id = "syncthingtray";}
        {app_id = "SchildiChat";}
        {app_id = "com.nextcloud.desktopclient.nextcloud";}
        {app_id = "gnome-system-monitor";}
        {title = "(?:Open|Save) (?:File|Folder|As)";}
        {title = "Add";}
        {title = "com-jgoodies-jdiskreport-JDiskReport";}
        {class = "discord";}
        {window_role = "pop-up";}
        {window_role = "bubble";}
        {window_role = "dialog";}
        {window_role = "task_dialog";}
        {window_role = "menu";}
        {window_role = "Preferences";}
      ];
      titlebar = false;	
    };
    window = {
      commands = [
        {
          command = "opacity 0.95";
          criteria = {
            class = ".*";
          };
        }
        {
          command = "opacity 1";
          criteria = {
            app_id = "firefox";
          };
        }
        {
          command = "sticky enable, shadows enable";
          criteria = {
            app_id="firefox"; 
            title="^Picture-in-Picture$";
          };
        }
      ];	
    };
    gaps = {
      inner = 5;
    };
  };
  #wrapperFeatures = {
  #    gtk = true;
  #  };
  extraConfig =let 
    modifier = config.wayland.windowManager.sway.config.modifier;
  in "
exec_always autotiling
set $exit \"exit: [s]leep, [p]oweroff, [r]eboot, [l]ogout\"
mode $exit {

    bindsym --to-code {
        s exec \"systemctl suspend\", mode \"default\"
        p exec \"systemctl poweroff\"
        r exec \"systemctl reboot\"
        l exec \"swaymsg exit\"

        Return mode \"default\"
        Escape mode \"default\"
        ${modifier}+x mode \"default\"
    }
}

workspace 1:一

#include ~/.config/sway/config.d/*
#exec \"bash ~/.config/scripts/startup.sh\"

";	
};

}
