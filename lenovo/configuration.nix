# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
   
  #nix = {
  #package = pkgs.nixFlakes;
  #extraOptions = ''
  #  experimental-features = nix-command flakes
  #'';
#};
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # correct time between linux and windows
  time.hardwareClockInLocalTime = true;

  # wayland-related
  security.polkit.enable = true;
  hardware.opengl = {
	enable = true;
	driSupport = true;
	driSupport32Bit = true;
	};


  # nvidia stuff
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {

    # Modesetting is needed most of the time
    modesetting.enable = true;

	# Enable power management (do not disable this unless you have a reason to).
	# Likely to cause problems on laptops and with screen tearing if disabled.
	powerManagement.enable = true;

    # Use the open source version of the kernel module ("nouveau")
	# Note that this offers much lower performance and does not
	# support all the latest Nvidia GPU features.
	# You most likely don't want this.
    # Only available on driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
	sync.enable =  true;
	# Make sure to use the correct Bus ID values for your system!
	intelBusId = "PCI:0:2:0";
	nvidiaBusId = "PCI:1:0:0";
	};
  };

  # audio
  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.configFile = pkgs.runCommand "default.pa" {} ''
  sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
    ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
  '';


  # bluetooth
  hardware.bluetooth.enable = true;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  # fonts
  fonts.packages = with pkgs; [
  font-awesome_5
  emacs-all-the-icons-fonts
  fira-code
  nerdfonts
  ];
  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "nodeadkeys";
  };


  # enable blueman
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.swarsel = {
    isNormalUser = true;
    description = "Leon S";
    extraGroups = [ "networkmanager" "wheel" "lp" ];
    packages = with pkgs; [];
  };
  
 # nix.settings.allowed-users = [
#	"*"
#	];

  # Enable automatic login for the user.
  # services.getty.autologinUser = "swarsel";

  # Run Sway on startup
  #environment.loginShellInit = ''
  #  [[ "$(tty)" == /dev/tty1 ]] && sway
  #'';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
#  let
#	my-python-packages = ps: with ps; [
#		pandas
#		requests
#		scipy
#		numpy
#		matplotlib
#	];
# in
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    rustup
    gcc
    gnumake
  fira-code
  font-awesome_5
  emacs-all-the-icons-fonts
  nerdfonts
  (python3.withPackages(ps: with ps; [ pandas requests numpy scipy matplotlib python-lsp-server debugpy]))
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
 
  # Sway stuff
  #programs.sway.enable = true;
  #xdg.portal.wlr.enable = true;

  # dconf
  programs.dconf.enable = true;
  
  # zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  environment.pathsToLink = [ "/share/zsh" ];
  
  # emacs
  #services.emacs = {
  #enable = true;
  #defaultEditor = true;
  #};

  # Backlight
  # programs.light.enable = true;

  # List services that you want to enable:


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
