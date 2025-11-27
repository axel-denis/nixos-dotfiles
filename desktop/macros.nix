{ config, pkgs, unstable, inputs, ... }:
{
#  services.udev.extraRules = ''
#    KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="Hengchangtong  HCT USB Entry Keyboard System Control", SYMLINK+="input/numpad1"
#  '';


  services = {
    evsieve.enable = true;
  };
}

