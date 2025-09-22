{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, quickshell, dgop, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      packages.${system}.default = pkgs.hello;

      nixosConfigurations.hestia = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/hestia.nix
          ./modules/system.nix
          home-manager.nixosModules.home-manager

          {
            _module.args = { inherit home-manager quickshell dgop; };
          }

          ({ pkgs, ... }: {
            environment.systemPackages = [
              quickshell.packages.${system}.default
              dgop.packages.${system}.default
            ];
          })
        ];
      };
    };
}
