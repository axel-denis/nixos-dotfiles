{ config, pkgs, unstable, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    catppuccin-cursors.frappeFlamingo
    hyprpicker
    cava
    waybar
    swaynotificationcenter
    playerctl
    nemo
    kitty
    wl-clipboard # for screenshot
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
    grim # recheck
    slurp # recheck
    hyprpaper
    pavucontrol # recheck
    discord
    spotify
 
    (where-is-my-sddm-theme.override {
        variants = ["qt5"];
    })

    cudaPackages.cuda_cudart
    cudatoolkit
    (unstable.blender.override { # long to build
      cudaSupport = true;
    })
    #unstable.blender

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

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}
