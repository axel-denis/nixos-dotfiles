{ config, pkgs, inputs, ... }:

let
  dotfilesRepoUrl = "https://github.com/axel-denis/hyprland-dotfiles.git";
  #dotfilesCommitHash = "205ec7c7cb9ab17ec80c23ce0e53ef1708fd26ab"; # commit hash

  dotfilesRepo = pkgs.fetchgit {
    url = dotfilesRepoUrl;
    rev = "refs/tags/1.1";
    hash = "sha256-UB/cAd9Btg25g8JrS3NQOj+gkNZVamFTVEyAe2XG2pU="; 
    # NOTE - idk how to found this hash, found it only because if you don't set it, the error specifies it.
  };

  # Get all users with home directories
  usersWithHome = pkgs.lib.filterAttrs (name: user: ((user.home != null) && (pkgs.lib.hasPrefix "/home/" user.home))) config.users.users;

in {
  # copying dotfiles configs to /home/$user/.config
  system.activationScripts.copyDotfiles = {
    text = pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (username: user: ''
      echo "Copying dotfiles to ${username}'s .config..."
      config_dir="${user.home}/.config"
      
      # Create .config directory if it doesn't exist
      ${pkgs.coreutils}/bin/mkdir -p "$config_dir"
      
      # Copy contents with rsync, preserving permissions
      #${pkgs.rsync}/bin/rsync -rlpt --chown=${username}:users --delete \
      #  ${dotfilesRepo}/ "$config_dir/"
      ${pkgs.coreutils}/bin/cp -rf "${dotfilesRepo}/." "$config_dir/"
    '') usersWithHome);

    # The activation script should run after filesystems are mounted
    deps = [ "users" "groups" ];
  };
}
