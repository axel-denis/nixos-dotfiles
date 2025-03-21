{ config, pkgs, ... }:

let
  # Git repository configuration
  themeRepoUrl = "https://github.com/stepanzubkov/where-is-my-sddm-theme.git";
  themeCommitHash = "4afb855bc07f3aa8a327aa9cfc03c3d00b242212"; #commit hash

  themeRepo = builtins.fetchGit {
    url = themeRepoUrl;
    rev = themeCommitHash;
  };

  customSddmTheme = pkgs.stdenv.mkDerivation {
    name = "where_is_my_sddm_theme";
    src = themeRepo;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/
      cp -r $src/where_is_my_sddm_theme $out/share/sddm/themes/where_is_my_sddm_theme/
    '';
  };

in {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme";

/*
    settings = {
      Theme = {
        Current = "where_is_my_sddm_theme";
        ThemeDir = "${config.system.path}/share/sddm/themes";
      };
    };*/
  };

  environment.systemPackages = [ customSddmTheme ];

  # Ensure theme directory exists with correct permissions
  systemd.tmpfiles.rules = [
    "L+ /usr/share/sddm/themes/where_is_my_sddm_theme - - - - ${customSddmTheme}/share/sddm/themes/where_is_my_sddm_theme"
  ];

  # Nuclear path cleanup
  system.activationScripts.sddmThemeFix = ''
    # Remove legacy theme locations
    rm -rf /usr/share/sddm/themes/where_is_my_sddm_theme
    rm -rf /etc/sddm/themes/where_is_my_sddm_theme
    
    # Force link to our theme
    ln -sfn ${customSddmTheme}/share/sddm/themes/where_is_my_sddm_theme \
            /usr/share/sddm/themes/where_is_my_sddm_theme
  '';
}
