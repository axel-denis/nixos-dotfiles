{ config, pkgs, ... }:

let
  hyprlandConfigRepo = "https://github.com/axel-denis/hyprland-dotfiles.git";
  hyprlandConfigRev = "main";
  hyprlandConfigDir = "/etc/hyprland-config/hypr";

  # Read all .conf files from hyprland-config directory
  configFileNames = builtins.attrNames (builtins.readDir "${hyprlandConfigDir}");

  # Filter only .conf files
  confFiles = builtins.filter 
    (name: pkgs.lib.strings.hasSuffix ".conf" name) 
    configFileNames;  
  # Combine all config files into one string
  combinedConfig = builtins.concatStringsSep "\n\n" 
    (map (filename: builtins.readFile "${hyprlandConfigDir}/${filename}") confFiles);

  # Generate sorted and formatted final config
  hyprlandConfig = combinedConfig;
in {
  # hyprland
  programs.hyprland.enable = true;

  environment.etc."hypr/hyprland.conf".text = hyprlandConfig;
  # Apply configuration to all users
#  environment.homeDir = ".config";
  environment.extraInit = ''
    mkdir -p /home/$USER/.config/hypr
    ln -sf /etc/hypr/hyprland.conf /home/$USER/.config/hypr/hyprland.conf
  '';


  services.displayManager.defaultSession = "hyprland";
}
