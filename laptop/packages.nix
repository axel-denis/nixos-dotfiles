{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    arduino-ide
    cargo
    nodejs_23
    wl-clipboard
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
}