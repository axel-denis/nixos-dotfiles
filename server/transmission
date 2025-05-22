{ config, pkgs, inputs, ... }:
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.transmission = {
      image = "haugene/transmission-openvpn";
      autoStart = false;
      extraOptions = [ "--cap-add=NET_ADMIN" ];

      volumes = [
        "/mnt/transmission/torrents_dl:/data"
        "/mnt/transmission/torrents_config:/config"
      ];

      environment = {
        OPENVPN_PROVIDER = "WINDSCRIBE";
        OPENVPN_CONFIG = "Brussels-Guildhouse-udp";
        #OPENVPN_USERNAME = "in env file";
        #OPENVPN_PASSWORD = "in env file";
        LOCAL_NETWORK = "192.168.0.0/16";
        WEBPROXY_ENABLED = "false";
        TRANSMISSION_WEB_UI = "flood-for-transmission";
      };
      environmentFiles = [ "/etc/nixos/.env" ];
      ports = [ "9091:9091" ];

#      log-driver = "json-file";
#      log-opts = {
#        "max-size" = "10m";
#      };
    };
  };
}
