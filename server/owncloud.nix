{ config, containersRoot, ... }:

let
  # Define paths for OwnCloud data
  owncloudRoot = "${containersRoot}/owncloud"; 
  owncloudData = "${owncloudRoot}/data";
  owncloudConfig = "${owncloudRoot}/config";

  # PostgreSQL configuration
  postgresRoot = "${owncloudRoot}/pgsql";
  postgresPassword = "yourpassword"; # NOTE - Replace with a secure password
  postgresUser = "owncloud";
  postgresDb = "owncloud";

  # Redis configuration
  redisRoot = "${owncloudRoot}/redis";

in {
  # Define the PostgreSQL container
  virtualisation.oci-containers.containers.owncloud-postgres = {
    image = "postgres:13";
    environment = {
      POSTGRES_PASSWORD = postgresPassword;
      POSTGRES_USER = postgresUser;
      POSTGRES_DB = postgresDb;
    };
    volumes = [
      "${postgresRoot}:/var/lib/postgresql/data"
    ];
    extraOptions = [
      "--network=owncloud-net"
    ];
  };

  # Define the Redis container
  virtualisation.oci-containers.containers.owncloud-redis = {
    image = "redis:6.2-alpine";
    volumes = [
      "${redisRoot}:/data"
    ];
    extraOptions = [
      "--network=owncloud-net"
    ];
  };

  # Define the OwnCloud container
  virtualisation.oci-containers.containers.owncloud = {
    image = "owncloud/server:latest";
    ports = ["8888:8080"];
    environment = {
      OWNCLOUD_DB_TYPE = "pgsql";
      OWNCLOUD_DB_HOST = "owncloud-postgres";
      OWNCLOUD_DB_NAME = postgresDb;
      OWNCLOUD_DB_USERNAME = postgresUser;
      OWNCLOUD_DB_PASSWORD = postgresPassword;
      OWNCLOUD_REDIS_ENABLED = "true";
      OWNCLOUD_REDIS_HOST = "owncloud-redis";
      OWNCLOUD_DOMAIN = "192.168.122.40"; # NOTE - change to your domain
      OWNCLOUD_TRUSTED_DOMAINS = "192.168.122.40"; # NOTE - same
    };
    volumes = [
      "${owncloudData}:/mnt/data"
      "${owncloudConfig}:/etc/owncloud"
    ];
    extraOptions = [
      "--network=owncloud-net"
    ];
  };

  # Create the Docker network for OwnCloud
  systemd.services.init-owncloud-network = {
    description = "Create the network bridge for OwnCloud.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
            in ''
              # owncloud-net network
              check=$(${dockercli} network ls | grep "owncloud-net" || true)
              if [ -z "$check" ]; then
                ${dockercli} network create owncloud-net
              else
                echo "owncloud-net already exists in docker"
              fi
            '';
  };
}
