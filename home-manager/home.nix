# Adapted from: https://github.com/Misterio77/nix-starter-configs/blob/main/minimal/home-manager/home.nix
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./vcs.nix
    ./term.nix
  ];

  home = {
    username = "bowen";
    homeDirectory = "/home/bowen";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
