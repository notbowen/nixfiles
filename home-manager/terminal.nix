{ config, lib, pkgs, ... }:

{
  # Zsh (Shell)
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # NixOS stuff
      update-home = "home-manager --flake /home/bowen/.nixfiles switch --impure";
      update-system = "sudo nixos-rebuild switch --impure";

      # My stuff
      lg = "lazygit";
    };

    history.size = 10000;
  };

  # Starship (Terminal)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Exa (`ls` replacement)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}

