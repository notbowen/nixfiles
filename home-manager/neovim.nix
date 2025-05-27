{ config, lib, pkgs, ... }:

{
  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  # Configure `init.lua` file
  xdg.configFile = {
    nvim = {
      source =
        config.lib.file.mkOutOfStoreSymlink
        "/home/bowen/.nixfiles/nvim";
      recursive = true;
    };
  };

  # Kickstart.nvim Requirements
  home.packages = with pkgs; [
    ripgrep
  ];
}

