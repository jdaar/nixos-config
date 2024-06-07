{
  description = "Jhonatan's config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
  let 
	  inherit (self) outputs;
	  system = "x86_64-linux";
	in
    {
	    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
	      pkgs = import nixpkgs {
		  	  inherit system;
		  	  config.allowUnfree = true;
		      config.allowUnfreePredicate = (pkg: true);
	      };
	      specialArgs = {inherit inputs system;};
	      modules = [
		      ./hosts/default/configuration.nix
		      {
			      home-manager.useGlobalPkgs = true;
		      }
	      ];
	    };
    };
}
