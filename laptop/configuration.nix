{ config, pkgs, inputs, ... }:
{
  imports = [ ./cachix.nix ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
#  boot.loader.grub.enable = pkgs.lib.mkForce true;
#  boot.loader.grub.device = "/dev/vda";
#  boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  time.timeZone = "Europe/Paris";

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = true;
  programs.hyprland.enable = true;
  services.displayManager.defaultSession = "hyprland";
  services.fail2ban.enable = true; # block repeated ssh login attemps
  services.tlp.enable = true; # power gestion/savings

  networking.hosts = {
    "192.168.122.161" = ["photos.example.com" "films.example.com" "transmission.example.com"];
  };


  # nvidia
  services.hardware.bolt.enable = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;

  # allows wireguard to pass the firewall
  # import a wireguard file with :
  # nmcli connection import type wireguard file filename.conf
  networking.firewall = {
   # if packets are still dropped, they will show up in dmesg
   logReversePathDrops = true;
   # wireguard trips rpfilter up
   extraCommands = ''
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 65142 -j RETURN
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 65142 -j RETURN
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51877 -j RETURN
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51877 -j RETURN
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 4264 -j RETURN
     ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 4264 -j RETURN
   '';
   extraStopCommands = ''
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 65142 -j RETURN || true
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 65142 -j RETURN || true
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51877 -j RETURN || true
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51877 -j RETURN || true
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 4264 -j RETURN || true
     ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 4264 -j RETURN || true
   '';
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
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

  # enable ssh
  services.openssh = {
    enable = false;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
    };
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme_qt5";
  };

  programs.git.enable = true;

  environment.interactiveShellInit = ''
    alias update='curl -sSL https://raw.githubusercontent.com/axel-denis/nixos-dotfiles/main/install.sh | nix-shell -p git --run "sh -s -- laptop"'
    #alias trimgen='curl https://gist.githubusercontent.com/MaxwellDupre/3077cd229490cf93ecab08ef2a79c852/raw/ccb39ba6304ee836738d4ea62999f4451fbc27f7/trim-generations.sh | sudo bash -s 3 0 system'
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
