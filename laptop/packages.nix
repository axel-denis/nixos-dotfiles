{ config, pkgs, inputs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
#  boot.loader.grub.enable = pkgs.lib.mkForce true;
#  boot.loader.grub.device = "/dev/vda";
#  boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  time.timeZone = "Asia/Seoul";

  networking.networkmanager.enable = true;
  programs.hyprland.enable = true;
  services.displayManager.defaultSession = "hyprland";
  services.fail2ban.enable = true; # block repeated ssh login attemps
  services.tlp.enable = true; # power gestion/savings

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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

➜  ~ cat /etc/nixos/packages.nix 
{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    neofetch
    pkgs.kitty # required for the default Hyprland config
    rsync # for dotfiles copy

    wofi
    vscode
    firefox
    brightnessctl
    pipewire
    wireplumber # check if the two are necessary
    grim # recheck
    slurp # recheck
    waybar # recheck
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
    (where-is-my-sddm-theme.override {
        variants = ["qt5"];
    })
    blender
  ];
  fonts.packages = with pkgs; [ inter monaspace nerdfonts ];
  fonts.enableDefaultPackages = true;
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Inter" ];
      serif = [ "Inter" ];
      monospace = [ "Monaspace Neon" ];
    };
  };

  services.flatpak.enable = true;
  # run with flatpak run (full package name)
  services.flatpak.packages = [
    # TODO - does not detect tlp...
    "com.github.d4nj1.tlpui"
  ];
}
