{
  description = "NixOS configuration for hestia";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
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

  outputs = { self, nixpkgs, chaotic, home-manager, quickshell, dgop, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.hestia = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit chaotic; };
        modules = [
          ./hosts/hestia.nix
          ./modules/system.nix
          home-manager.nixosModules.home-manager
          chaotic.nixosModules.default
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
