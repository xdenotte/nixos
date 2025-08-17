{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, quickshell, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      commonModules = [
        ./hosts/hestia.nix
        ./modules/system.nix
        home-manager.nixosModules.home-manager
        {
          _module.args = { inherit home-manager quickshell; };
        }
        {
          environment.systemPackages = [
            quickshell.packages.${system}.default
          ];
        }
      ];
    in
    {
      nixosConfigurations.hestia = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = commonModules;
      };

      packages.${system}.default = pkgs.hello;
    };
}
