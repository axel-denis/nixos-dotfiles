{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    neofetch
    pkgs.kitty # required for the default Hyprland config
    rsync # for dotfiles copy

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

  services.flatpak.enable = true;
  # run with flatpak run (full package name)
  services.flatpak.packages = [
    # TODO - does not detect tlp...
    "com.github.d4nj1.tlpui"
  ];
}