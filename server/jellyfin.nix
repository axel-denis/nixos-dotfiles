{ config, containersRoot, ... }:

let
  jellyfinRoot = "${containersRoot}/jellyfin";

in {
  virtualisation.oci-containers.containers = {
    jellyfin = {
      image = "jellyfin/jellyfin:latest";
      ports = ["8096:8096"];
      volumes = [
        "${jellyfinRoot}/media:/media"
        "${jellyfinRoot}/config:/config"
      ];
    };
  };
}
