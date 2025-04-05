{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    neofetch
    pkgs.kitty # required for the default Hyprland config
    wl-clipboard
    nixfmt-classic
    wofi
    tree
    hyprlock
    direnv
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

    vscode.fhs # fhs allows for extensions to use internal binaries
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

  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "Hibernate";
  };

  services.flatpak.enable = true;
  # run with flatpak run (full package name)
  services.flatpak.packages = [
    # TODO - does not detect tlp...
    "com.github.d4nj1.tlpui"
  ];
}