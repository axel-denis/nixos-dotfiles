{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    arduino-ide

    #libreoffice & speell check
    libreoffice-qt
    hunspell
    hunspellDicts.fr-any
#    hunspellDicts.en_US
  ];

  # for arduino ide to compile to renesas board
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "arduino_renesas_core_rules";
      text = ''
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", MODE:="0666"
      '';

      destination = "/etc/udev/rules.d/60-arduino-renesas.rules";
    })
  ];

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["axel"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}