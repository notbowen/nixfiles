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

  # System packages
  environment.systemPackages = with pkgs; [
    wget
  ];

  # WSL Configuration
  wsl.enable = true;
  wsl.defaultUser = "bowen";

  # Set hostname
  networking.hostName = "nixos";

  # Enable ZSH
  programs.zsh.enable = true;

  # VSCode Workaround
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld;
  };

  # Configure system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    bowen = {
      initialPassword = "root";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGCNkDOrVKbSwMSRYyVAEMSfG9wFYdIB7GNwB/kSZ322 bowen@MacDonels.local"
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
  system.stateVersion = "25.05";
}
