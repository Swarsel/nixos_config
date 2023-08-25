# /etc/nixos/flake.nix
{
  description = "Config flake";

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
          			./lenovo/configuration.nix
	  			home-manager.nixosModules.home-manager {
    					home-manager.useGlobalPkgs = true;
    					home-manager.useUserPackages = true;
    					home-manager.users.swarsel = import lenovo/home.nix;
  				}
        		];
		};
    
    	# some future setup that only uses home manager on a non NixOS machine
    	
		surface = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [ 
				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.swarsel = import surface/home.nix;
				}
			];
		};
	};                	
  };
}
