{ config, pkgs, unstable, inputs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.grub.enable = pkgs.lib.mkForce true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.

  time.timeZone = "Europe/Paris";

  networking.networkmanager.enable = true;

  programs.hyprland = {
    enable = true;
#    package = inputs.unstableHyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    package = unstable.hyprland;
  };

  services.displayManager.defaultSession = "hyprland";
  services.fail2ban.enable = true; # block repeated ssh login attemps

  # nvidia
  services.hardware.bolt.enable = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [
    "en_US.UTF-8/UTF-8"
    "fr_FR.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF8";
    LC_ADDRESS = "es_VE.UTF-8";
    LC_IDENTIFICATION = "es_VE.UTF-8";
    LC_MEASUREMENT = "es_VE.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_MONETARY = "es_VE.UTF-8";
    LC_NAME = "es_VE.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "es_VE.UTF-8";
    LC_TELEPHONE = "es_VE.UTF-8";
    LC_TIME = "es_VE.UTF-8";
    LC_COLLATE = "es_VE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # enable oh my zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "robbyrussell";
    plugins = [ "direnv" ];
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme_qt5";
  };

  programs.git.enable = true;

  environment.etc."zshrc".text = ''
    ns() {
      if [ "$#" -eq 0 ]; then
        echo "Usage: ns <package1> [package2 ...]"
        return 1
      fi

      local args=()
      for pkg in "$@"; do
        args+=("nixpkgs#$pkg")
      done

      nix shell "''${args[@]}"
    }
  '';

  environment.interactiveShellInit = ''
    alias update='curl -sSL https://raw.githubusercontent.com/axel-denis/nixos-dotfiles/main/install.sh | nix-shell -p git --run "sh -s -- desktop"'
    #alias trimgen='curl https://gist.githubusercontent.com/MaxwellDupre/3077cd229490cf93ecab08ef2a79c852/raw/ccb39ba6304ee836738d4ea62999f4451fbc27f7/trim-generations.sh | sudo bash -s 3 0 system'
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
