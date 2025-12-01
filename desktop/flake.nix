{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstableNixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs, unstableNixpkgs, ...
    }:
    let 
    	system = "x86_64-linux";
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
       	  inherit inputs; 
	  unstable = import unstableNixpkgs {
	    inherit system;
	    config.allowUnfree = true;
	  };
        };

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          ./packages.nix
          ./main_packages.nix
          ./users.nix
          ./dotfiles.nix
          ./filesystems.nix
#          ./macros.nix
        ];
      };
    };
}
