{ config, pkgs, inputs, ... }:
{
  users.users.axel = {
    isNormalUser = true;
    description = "Axel";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [];
  };
}
