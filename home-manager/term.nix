{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set relativenumber
      syntax enable
    '';
  };
}

