{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    ruff
    uv

    nodejs_24
    python313
    rustup
  ];
}

