# install from the standard iso

- Download the iso with the Gnome installer
- Install trough the standard process
  - Create an user and a password in the installer
  - Do not enable any desktop env (if for server, otherwise do as you please)
  - Install
- Restart and login to your user

# Config setup
> [!NOTE]
> The configuration file is located at `/etc/nixos/configuration.nix` and can be edited with `sudo nano...`
> After an edit, apply the configuration with `sudo nixos-rebuild switch`

## if unable to paste the config

- Enable ssh by adding `services.openssh.enable = true;` in the config and apply it.
- Login from oustide with `TERM=xterm ssh user@nixos-ip`
- You can now paste from another computer using ssh

## if able to paste
You can now add the configuration from this repo (*A lot of things need to be changed, like the user, the ssh key, etc*)
> [!NOTE]
> The configuration forbid ssh login by password, you need to use your private ssh key:
> (example) `TERM=xterm ssh -i ~/.ssh/for_nixosvm user@ip`
