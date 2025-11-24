{ config, pkgs, inputs, ... }:

let
  dotfilesRepoUrl = "https://github.com/axel-denis/hyprland-dotfiles.git";

  dotfilesRepo = builtins.fetchGit {
    url = dotfilesRepoUrl;
    rev = "1747bcd394d3d141db400822b5d7df010d93b277"; # desktop branch
  };

  # Get all users with home directories
  usersWithHome = pkgs.lib.filterAttrs (name: user:
    ((user.home != null) && (pkgs.lib.hasPrefix "/home/" user.home)))
    config.users.users;

in {
  # copying dotfiles configs to /home/$user/.config
  system.activationScripts.copyDotfiles = {
    text = pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList
      (username: user: ''
        echo "Copying dotfiles to ${username}'s .config..."
        config_dir="${user.home}/.config"

        # Create .config directory if it doesn't exist
        ${pkgs.coreutils}/bin/mkdir -p "$config_dir"

        # Copy contents with rsync, preserving permissions
        #${pkgs.rsync}/bin/rsync -rlpt --chown=${username}:users --delete \
        #  ${dotfilesRepo}/ "$config_dir/"
        ${pkgs.coreutils}/bin/cp -rf "${dotfilesRepo}/." "$config_dir/"
        ${pkgs.coreutils}/bin/chown -R "$username" "$config_dir"
        ${pkgs.coreutils}/bin/chmod +x "$config_dir/hypr/focus.sh"
      '') usersWithHome);

    # The activation script should run after filesystems are mounted
    deps = [ "users" "groups" ];
  };
}
