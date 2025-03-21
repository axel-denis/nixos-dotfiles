{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel/2be9f1ef6c2df2ecf0eebe5a039e8029d8d151cd"; # Mar 2 2025
#    hyprswitch.url = "github:h3rmt/hyprswitch/release";
    matugen.url = "github:/InioX/Matugen";
    /*tlpui = {
      url = "github:d4nj1/TLPUI";
      flake = false;
    };*/
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=5e54c3c"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nix-flatpak, nixos-generators, ... }: let
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
        nix-flatpak.nixosModules.nix-flatpak
        ./hardware-configuration.nix
        ./configuration.nix
      ];
    };
    packages.${system}.iso = nixos-generators.nixosGenerate {
      inherit system;
      modules = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
        ./configuration.nix
        # Add any ISO-specific overrides here if needed
      ];
      specialArgs = { inherit inputs; };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.hyprpanel.overlay
 #         inputs.hyprswitch.overlays
        ];
      };
      format = "iso";
    };
  };
}
