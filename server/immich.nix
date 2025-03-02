{ config, containersRoot, ... }:

let
  # Define paths for Immich data
  immichRoot = "${containersRoot}/immich"; # Base directory for Immich
  immichPhotos = "${immichRoot}/photos"; # Directory for photos
  immichAppdataRoot = "${immichRoot}/appdata"; # Directory for app data

  # PostgreSQL configuration
  postgresRoot = "${immichAppdataRoot}/pgsql"; # Directory for PostgreSQL data
  postgresPassword = "yourpassword"; # Replace with a secure password
  postgresUser = "immich";
  postgresDb = "immich";

  # Immich version (e.g., "release" or a specific version tag)
  immichVersion = "release";

in {
  # Enable Docker
  virtualisation.docker.enable = true;

  # Define Docker containers for Immich
  virtualisation.oci-containers.containers = {
    immich = {
      image = "ghcr.io/immich-app/immich-server:${immichVersion}";
      ports = ["2283:2283"];
      environment = {
        IMMICH_VERSION = immichVersion;
        DB_HOSTNAME = "immich_postgres";
        DB_USERNAME = postgresUser;
        DB_DATABASE_NAME = postgresDb;
        DB_PASSWORD = postgresPassword;
        REDIS_HOSTNAME = "immich_redis";
      };
      volumes = [
        "${immichPhotos}:/usr/src/app/upload"
        "/etc/localtime:/etc/localtime:ro"
      ];
      extraOptions = [
        "--network=immich-net"
      ];
    };

    immich_machine_learning = {
      image = "ghcr.io/immich-app/immich-machine-learning:${immichVersion}";
      environment = {
        IMMICH_VERSION = immichVersion;
      };
      volumes = [
        "${immichAppdataRoot}/model-cache:/cache"
      ];
      extraOptions = [
        "--network=immich-net"
      ];
    };

    immich_redis = {
      image = "redis:6.2-alpine@sha256:905c4ee67b8e0aa955331960d2aa745781e6bd89afc44a8584bfd13bc890f0ae";
      extraOptions = [
        "--network=immich-net"
      ];
    };

    immich_postgres = {
      image = "tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";
      environment = {
        POSTGRES_PASSWORD = postgresPassword;
        POSTGRES_USER = postgresUser;
        POSTGRES_DB = postgresDb;
      };
      volumes = [
        "${postgresRoot}:/var/lib/postgresql/data"
      ];
      extraOptions = [
        "--network=immich-net"
      ];
    };
  };

  # Create the Docker network for Immich
  systemd.services.init-immich-network = {
    description = "Create the network bridge for Immich.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
            in ''
              # immich-net network
              check=$(${dockercli} network ls | grep "immich-net" || true)
              if [ -z "$check" ]; then
                ${dockercli} network create immich-net
              else
                echo "immich-net already exists in docker"
              fi
            '';
  };
}
