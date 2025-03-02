{ config, ... }:

let
  homePath = "/home/axel";
  containersRoot = "${homePath}/containers";
in {
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = false;
  virtualisation.oci-containers.backend = "docker";

  imports = [
    (import ./immich.nix { inherit config containersRoot; })
    (import ./jellyfin.nix { inherit config containersRoot; })
#    (import ./transmission.nix { inherit config containersRoot homePath; }) # need to be corrected and password protected
  ];
}
