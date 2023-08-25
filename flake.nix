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
	  home-manager.nixosModules.home-manager
  		{
    		home-manager.useGlobalPkgs = true;
    		home-manager.useUserPackages = true;
    		home-manager.users.swarsel = import /home/swarsel/.config/home-manager/home.nix;
  		}
        ];
      };
    };
  };
}
