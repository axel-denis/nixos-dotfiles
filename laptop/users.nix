{ config, pkgs, inputs, ... }:
{
  users.users.axel = {
    isNormalUser = true;
    description = "Axel";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6TnZanVTSOFIoGj7CxP7MygdM9G9Pxzm7FgqbMnxi9 axel@rarch" ];
  };
}