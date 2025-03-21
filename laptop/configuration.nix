# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  # Git repository configuration
  dotfilesRepoUrl = "https://github.com/axel-denis/hyprland-dotfiles.git";
  dotfilesCommitHash = "205ec7c7cb9ab17ec80c23ce0e53ef1708fd26ab"; # commit hash

  dotfilesRepo = builtins.fetchGit {
    url = dotfilesRepoUrl;
    rev = dotfilesCommitHash;
  };

  # Get all users with home directories
  usersWithHome = pkgs.lib.filterAttrs (name: user: ((user.home != null) && (pkgs.lib.hasPrefix "/home/" user.home))) config.users.users;

in {

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ./hyprland.nix
      ./ssdm.nix # login screen
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.hyprland.enable = true;
  services.displayManager.defaultSession = "hyprland";

  # copying configs to /home/$user/.config
  system.activationScripts.copyDotfiles = {
    text = pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (username: user: ''
      echo "Copying dotfiles to ${username}'s .config..."
      config_dir="${user.home}/.config"
      
      # Create .config directory if it doesn't exist
      ${pkgs.coreutils}/bin/mkdir -p "$config_dir"
      
      # Copy contents with rsync, preserving permissions
      ${pkgs.rsync}/bin/rsync -rlpt --chown=${username}:users --delete \
        ${dotfilesRepo}/ "$config_dir/"
    '') usersWithHome);

    # The activation script should run after filesystems are mounted
    deps = [ "users" "groups" ];
  };



  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ko_KR.UTF-8";
    LC_IDENTIFICATION = "ko_KR.UTF-8";
    LC_MEASUREMENT = "ko_KR.UTF-8";
    LC_MONETARY = "ko_KR.UTF-8";
    LC_NAME = "ko_KR.UTF-8";
    LC_NUMERIC = "ko_KR.UTF-8";
    LC_PAPER = "ko_KR.UTF-8";
    LC_TELEPHONE = "ko_KR.UTF-8";
    LC_TIME = "ko_KR.UTF-8";
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
  };

  # run on terminal startup
  environment.etc."zprofile".text = ''
  '';

  # enable ssh
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
    };
  };
  services.fail2ban.enable = true; # block repeated ssh login attemps

  services.tlp.enable = true; # power gestion/savings

  # Define a user account.
  users.users.axel = {
    isNormalUser = true;
    description = "Axel";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6TnZanVTSOFIoGj7CxP7MygdM9G9Pxzm7FgqbMnxi9 axel@rarch" ];
  };

  # Allow unfree packages
#  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neofetch
    pkgs.kitty # required for the default Hyprland config
    git
    rsync # for dotfiles copy

    brightnessctl
#    nmtui # find alternative
    pipewire
    wireplumber # check if the two are necessary
    grim # recheck
    slurp # recheck
    waybar
    hyprpaper
    blueman
    pavucontrol
    swaylock # lock screen ?
    swaylock-effects
    webcord
    hyprpanel
    # hyprswitch failed for now
    inputs.matugen.packages.${system}.default
    spotify
    # TODO wireguard

    nixos-generators # remove if not making ISOs
  ];

  services.flatpak.enable = true;
  # run with flatpak run (full package name)
  services.flatpak.packages = [
    # TODO - does not detect tlp...
    "com.github.d4nj1.tlpui"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
