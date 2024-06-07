{
  description = "Home Manager configuration of jhonatan";

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
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnfreePredicate = (pkg: true);
      };
    in {
      homeConfigurations."jhonatan" =
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./jhonatan.nix ];
          extraSpecialArgs = { inherit inputs; };
        };
    };
}
