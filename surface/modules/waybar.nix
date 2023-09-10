{ config, pkgs, fetchFromGitHub, ... }:

{
  home.packages = with pkgs; [
    playerctl
    pavucontrol
    pamixer
    gnome.gnome-clocks
    wlogout    
    jdiskreport
    monitor
  ];

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
		#format= "CPU {usage:2}%";
		format = "{icon0} {icon1} {icon2} {icon3} {icon4} {icon5} {icon6} {icon7}";
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
}
