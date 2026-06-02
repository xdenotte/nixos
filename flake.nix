{
  description = "NixOS configuration for hestia";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-nix = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
    };
    blender-bin.url = "https://flakehub.com/f/edolstra/blender-bin/*";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, dms, niri-nix, blender-bin, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.hestia = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              niri-nix.overlays.niri-nix
            ];
          })
          ./hosts/hestia.nix
          ./modules/system.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
