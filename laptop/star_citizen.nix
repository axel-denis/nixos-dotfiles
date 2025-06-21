{config, pkgs, inputs, ...}: {

  environment.systemPackages = with pkgs; [
    # for star citizen (probably, should try to remove them)
    dxvk
    mesa
  ];

  # NixOS configuration for Star Citizen requirements
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };
}
