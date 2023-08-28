# /etc/nixos/flake.nix
{
  description = "Config flake";

  inputs = {
  	#nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    	# You can access packages and modules from different nixpkgs revs
    	# at the same time. Here's an working example:
    	#nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      	home-manager = {
		#url = "github:nix-community/home-manager/release-23.05";
    url = "github:nix-community/home-manager";
        	inputs.nixpkgs.follows = "nixpkgs";
    	};
  };

  outputs = { self, nixpkgs, home-manager }: {
    	nixosConfigurations = {
    		nixos = nixpkgs.lib.nixosSystem {
        		system = "x86_64-linux";
        		modules = [
          			./lenovo/configuration.nix
				./lenovo/greetd.nix
        		];
		};
	};    
    	# some future setup that only uses home manager on a non NixOS machine
    	
	homeConfigurations = {
		"swarsel@nixos" = home-manager.lib.homeManagerConfiguration {
			pkgs = nixpkgs.legacyPackages.x86_64-linux;
			#extraSpecialArgs = { inherit inputs outputs; };
			modules = [ 
				./lenovo/home.nix
				./lenovo/modules/waybar.nix
			];
		};
	};                	
  };
}
