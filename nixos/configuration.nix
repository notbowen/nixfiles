# Adapted from: https://github.com/Misterio77/nix-starter-configs/blob/main/minimal/nixos/configuration.nix
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # ./hardware-configuration.nix
    <nixos-wsl/modules>
  ];

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
    };
  };

  # WSL Configuration
  wsl.enable = true;
  wsl.defaultUser = "bowen";

  # Set hostname
  networking.hostName = "nixos";

  # Enable ZSH
  programs.zsh.enable = true;

  # Configure system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    bowen = {
      initialPassword = "root";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add SSH public key here
      ];
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
    };
  };

  # Setup SSH server
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
