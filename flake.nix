{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
<<<<<<< HEAD
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
=======
    flake-utils.url = "github:numtide/flake-utils";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

>>>>>>> c9ec1fe352bc1751d72d982acf551a4ff0b6810c
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

<<<<<<< HEAD
  outputs = { self, nixpkgs, home-manager, quickshell, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      packages.${system}.default = pkgs.hello;

=======
  outputs = { self, nixpkgs, flake-utils, home-manager, quickshell, stylix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        packages.default = pkgs.hello;
      }
    ) // {
>>>>>>> c9ec1fe352bc1751d72d982acf551a4ff0b6810c
      nixosConfigurations.hestia = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/hestia.nix
          ./modules/system.nix
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix

          {
            _module.args = { inherit home-manager quickshell; };
          }

          ({ pkgs, ... }: {
            environment.systemPackages = [
              quickshell.packages.${system}.default
            ];
          })
        ];
      };
    };
}
