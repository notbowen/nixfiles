{ config, pkgs, ... }:

{
  # Enable git and add SSH key for signing commits
  home.file.".ssh/allowed_signers".text =
    "* ${builtins.readFile /home/bowen/.ssh/id_ed25519.pub}";

  programs.git = {
    enable = true;
    userName = "notbowen";
    userEmail = "contact@hubowen.dev";

    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };

  # GH CLI for authentication w. GitHub
  programs.gh = {
    enable = true;
  };

  # TUI for git
  programs.lazygit = {
    enable = true;
  };
}
