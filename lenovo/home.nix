{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "swarsel";
  home.homeDirectory = "/home/swarsel";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  #keyboard config
  home.keyboard.layout = "de";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
	git
	firefox
	mako
	wl-clipboard
	wl-mirror
	kitty
	keychain
	gnome.gnome-clocks
	gnome.gnome-system-monitor
	gnome.gnome-control-center
	qalculate-gtk
	obsidian
	blueman
	syncthing
	nextcloud-client
	spotify
	autotiling
	schildichat-desktop-wayland
	exa
	wev
	brightnessctl
	playerctl
	networkmanagerapplet
        discord
	libappindicator-gtk3
	anki
	xdg-desktop-portal 
	grim
	slurp
	mu
	isync

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
  
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/swarsel/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    #EDITOR = "emacs";
    SDL_VIDEODRIVER="wayland";
    _JAVA_AWT_WM_NONREPARENTING=1;
    QT_QPA_PLATFORM="wayland";
    XDG_CURRENT_DESKTOP="sway";
    XDG_SESSION_DESKTOP="sway";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Services
#  services.gpg-agent = {
#	enable = true;
#	enableSshSupport = true;
#	};

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

  # Additional programs

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
		hmswitch = "cd ~/.dotfiles; home-manager --flake .#swarsel@nixos switch; cd -;";
		nswitch  = "cd ~/.dotfiles; sudo nixos-rebuild --flake .#nixos switch; cd -;"; 
		edithome = "nano ~/.dotfiles/lenovo/home.nix";
		editnix = "nano ~/.dotfiles/lenovo/configuration.nix";
	};
	enableAutosuggestions = true;
	enableCompletion = true;
	autocd = true;
	cdpath = [
		"/etc/nixos/"
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
};
		

  programs.waybar = {
	enable = true;
  };

  programs.emacs = {
    enable = true;
   };
	
  programs.password-store = {
	enable = true;
	package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
  };

 
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
	modifier = "Mod4";
        terminal = "kitty";
        menu = "wofi --show drun -Iib -l 5 -W 500 -x -10 -y -51";
        bars = [{ command = "waybar";}]; 
	input = {
               "*" = {
                	xkb_layout = "de";
                	xkb_options = "grp:win_space_toggle";
			xkb_variant = "nodeadkeys";                
		};
		"type:touchpad" = {
       			dwt = "enabled";
       			tap = "enabled";
       			natural_scroll = "enabled";
       			middle_emulation = "enabled";
   		};
        };
	keybindings = let
  		modifier = config.wayland.windowManager.sway.config.modifier;
		in lib.mkOptionDefault {
  		"${modifier}+q" = "kill";
  		"${modifier}+f" = "exec firefox";
  		"${modifier}+e" = "exec emacs";
  		"${modifier}+m" = "exec spotify";
  		"${modifier}+n" = "exec sway output eDP-1 transform normal, splith";
  		"${modifier}+t" = "exec sway output eDP-1 transform 90, splitv";
		"${modifier}+Shift+F12" = "move scratchpad";
		"${modifier}+F12" = "scratchpad show";
		"${modifier}+p" = "exec wl-mirror eDP-1";
		"${modifier}+c" = "exec qalculate-gtk";
		"${modifier}+x" = "mode $exit";
		"${modifier}+s" = "exec grim -g \"$(slurp)\" -t png - | wl-copy -t image/png";
		"${modifier}+i" = "exec \"bash ~/.config/scripts/startup.sh\"";
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
	output = {
		eDP-1 = {
   		mode = "1920x1080";
   		scale = "1";
		bg = "~/.config/wallpaper/lenovowp.png fill";
   		};
	};
	startup = [
	#{ command = "systemctl --user restart nextcloud-client"; always = true; }
	#{ command = "systemctl --user restart syncthingtray"; always = true; }
	#{ command = "systemctl --user restart syncthingtray";}
	#{ command = "systemctl --user restart nextcloud-client";}
	#{ command = "firefox"; }
	{ command = "exec \"bash ~/.config/scripts/startup.sh\"";}
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
  				{app_id = "python3";}
  				{app_id = "blueman";}
  				{app_id = "gnome-system-monitor";}
  				{title = "(?:Open|Save) (?:File|Folder|As)";}
  				{title = "Add";}
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

include ~/.config/sway/config.d/*
exec \"bash ~/.config/scripts/startup.sh\"

";	
  };
  
}
