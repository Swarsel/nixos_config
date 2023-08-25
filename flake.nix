# /etc/nixos/flake.nix
{
  description = "flake for Lenovo Nixos build";

  inputs = {
  	nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      	home-manager = {
		url = "github:nix-community/home-manager";
        	inputs.nixpkgs.follows = "nixpkgs";
    	};
  };

  outputs = { self, nixpkgs, home-manager }: {
    	nixosConfigurations = {
    		nixosadminpc = nixpkgs.lib.nixosSystem {
        		system = "x86_64-linux";
        		modules = [
          			./configuration.nix
	  			home-manager.nixosModules.home-manager {
    					home-manager.useGlobalPkgs = true;
    					home-manager.useUserPackages = true;
    					home-manager.users.swarsel = import ./home.nix;
  				}
        		];
		};
      	};
    
    	# some future setup that only uses home manager on a non NixOS machine
    	homeConfigurations = {
            	homeMachine = home-manager.lib.homeManagerConfiguration {
                	# Note: I am sure this could be done better with flake-utils or something
                	pkgs = import nixpkgs { system = "x86_64-linux"; };
                	modules = [ ./home.nix ]; # Defined later
            	};
        };
    
  };
}
