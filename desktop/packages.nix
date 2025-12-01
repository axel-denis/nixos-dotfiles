{ config, pkgs, unstable, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    bitwarden-desktop

    unstable.mpv # video player (for hdr testing)

/*    libreoffice-qt
    hunspell
    hunspellDicts.fr-any*/

    obs-studio

    prusa-slicer
  ];

  virtualisation.docker.enable = true;

  programs.steam = {
    enable = true;
    /*
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall =
      true; # Open ports in the firewall for Steam Local Network Game Transfers
    */
  };
}
