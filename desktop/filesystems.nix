{ ... }:
{
  fileSystems."/white/hdd1" = {
    device = "//192.168.0.101/hdd1";
    fsType = "cifs";
    options = [ "username=axel" "password=2304" "x-systemd.automount" "noauto" ];
  };

  fileSystems."/white/hdd2" = {
    device = "//192.168.0.101/hdd2";
    fsType = "cifs";
    options = [ "username=axel" "password=2304" "x-systemd.automount" "noauto" ];
  };

  fileSystems."/white/ssd1" = {
    device = "//192.168.0.101/ssd1";
    fsType = "cifs";
    options = [ "username=axel" "password=2304" "x-systemd.automount" "noauto" ];
  };
}
