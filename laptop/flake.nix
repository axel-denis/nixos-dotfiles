{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstableNixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprpanel.url =
      "github:Jas-SinghFSU/HyprPanel/2be9f1ef6c2df2ecf0eebe5a039e8029d8d151cd"; # Mar 2 2025
    #    hyprswitch.url = "github:h3rmt/hyprswitch/release";
    matugen.url = "github:/InioX/Matugen";
    /* tlpui = {
         url = "github:d4nj1/TLPUI";
         flake = false;
       };
    */
    nix-flatpak.url =
      "github:gmodena/nix-flatpak/?ref=5e54c3c"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    #nix-citizen.url = "github:LovingMelody/nix-citizen";
  };

  outputs = inputs@{ self, nixpkgs, unstableNixpkgs, nix-flatpak, nixos-generators, ...
    }: # add nix-citizen if needed
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
          overlays = [
            inputs.hyprpanel.overlay
          ];
        };
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          ./hardware-configuration.nix
          ./configuration.nix
          ./packages.nix
          ./main_packages.nix
          ./users.nix
          ./dotfiles.nix
          #./transmission.nix
          # ./star_citizen.nix
          # nix-citizen.nixosModules.StarCitizen
          # {
          #   # Cachix setup
          #   nix.settings = {
          #     substituters = [ "https://nix-citizen.cachix.org" ];
          #     trusted-public-keys = [
          #       "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
          #     ];
          #   };
          #   nix-citizen.starCitizen = {
          #     # Enables the star citizen module
          #     enable = true;
          #     # Additional commands before the game starts
          #     preCommands = ''
          #       export DXVK_HUD=compiler;
          #       export MANGO_HUD=1;
          #     '';
          #     # # This option is enabled by default
          #     # #  Configures your system to meet some of the requirements to run star-citizen
          #     # # Set `vm.max_map_count` default to `16777216` (sysctl(8))
          #     # #Set `fs.file-max` default to `524288` (sysctl(8))
          #     # #Also sets `security.pam.loginLimits` to increase hard (limits.conf(5))
          #     # # Changes outlined in  https://github.com/starcitizen-lug/knowledge-base/wiki/Manual-Installation#prerequisites
          #     # setLimits = false;
          #   };
          # }
        ];
      };
    };
}
