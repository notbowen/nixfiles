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
        "${config.home.homeDirectory}/.nixfiles/nvim";
      recursive = true;
    };
  };
}

