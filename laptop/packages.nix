{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    cargo
    nodejs_23
  ];
}
