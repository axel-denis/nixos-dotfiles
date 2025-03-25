{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    arduino
    cargo
    nodejs_23
  ];
}
