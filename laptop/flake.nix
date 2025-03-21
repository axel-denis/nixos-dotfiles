{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel/2be9f1ef6c2df2ecf0eebe5a039e8029d8d151cd"; # Mar 2 2025
#    hyprswitch.url = "github:h3rmt/hyprswitch/release";
    matugen.url = "github:/InioX/Matugen";
  };

  outputs = inputs@{ self, nixpkgs, ... }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.hyprpanel.overlay
 #         inputs.hyprswitch.overlays
        ];
      };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
