{ config, pkgs, unstable, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    catppuccin-cursors.frappeFlamingo
    hyprpicker
    cava
    swaynotificationcenter
    playerctl
    nemo
    neofetch
    pkgs.kitty # required for the default Hyprland config
    wl-clipboard
    nixfmt-classic
    wofi
    tree
    hyprlock
    jq # necessary for hyprland focus.sh
    direnv
    firefox
    (chromium.override {
      commandLineArgs = "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo";
    })
    brightnessctl
    pipewire
    wireplumber # check if the two are necessary
    grim # recheck
    slurp # recheck
    waybar # recheck
    hyprpaper
    blueman
    pavucontrol
    webcord
    hyprpanel
    # hyprswitch failed for now
    spotify
    # TODO wireguard
    (where-is-my-sddm-theme.override {
        variants = ["qt5"];
    })
#    cudaPackages.cuda_cudart
#    cudatoolkit
    /*(unstable.blender.override {
      cudaSupport = true;
    })*/
    unstable.blender

    vscode.fhs # fhs allows for extensions to use internal binaries
  ];
  fonts.packages = with pkgs; [ inter monaspace nerd-fonts.jetbrains-mono ];
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

  # hardware accel
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      #intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # auto mount usb:
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;

}
