# NIXOS Config
This is my nixos config for both my laptop and my server, along with some notes for me to remember.
I'm a newbie regarding NixOS, so if you happens to see this repo and have any advice, don't hesitate to open an issue !

> [!NOTE]
> I'm aware that a public ssh key is exposed in the config.
> Its only purpose is to allow a first connection as the config disable password ssh login. It isn't used in production.

## Install manually

- Download the iso with the Gnome installer
- Install trough the standard process
  - Create an user and a password in the installer
  - Do not enable any desktop env (if for server, otherwise do as you please)
  - Install
- Restart and login to your user

## Config setup
> [!NOTE]
> The configuration file is located at `/etc/nixos/configuration.nix` and can be edited with `sudo nano...`
> After an edit, apply the configuration with `sudo nixos-rebuild switch`

### if unable to paste the config / access physically

- Enable ssh by adding `services.openssh.enable = true;` in the config and apply it.
- Login from oustide with `TERM=xterm ssh user@nixos-ip`
- You can now paste from another computer using ssh

### if able to paste
You can now add the configuration from this repo (*A lot of things need to be changed, like the user, the ssh key, etc*)
> [!NOTE]
> The server configuration forbid ssh login by password, you need to use your private ssh key:
> (example) `TERM=xterm ssh -i ~/.ssh/for_nixosvm user@ip`

You can also upload folders (containing the config) with :
`scp -r ./config user@ip:/etc/nixos/`
