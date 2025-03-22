{
  description = "My server NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # iso generation :
    # nixos-generators.url = "github:nix-community/nixos-generators";
    # nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs /*nixos-generators*/, ... }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        ./containers.nix
      ];
    };
    /* # iso generation :
    packages.${system}.iso = nixos-generators.nixosGenerate {
      inherit system;
      modules = [
        ./configuration.nix
        ./containers.nix
        ./dotfiles.nix
        # Add any ISO-specific overrides here if needed
      ];
      specialArgs = { inherit inputs; };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      format = "iso";
    };
    */
  };
}
