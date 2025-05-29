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
  wsl.useWindowsDriver = true;
  nixpkgs.config.allowUnfree = true;


  # Set hostname
  networking.hostName = "nixos";

  # Enable ZSH
  programs.zsh.enable = true;

  # Enable Docker
  virtualisation.docker.enable = true;

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
      extraGroups = [
        "wheel"
        "docker"
      ];
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

  # NVIDIA on Docker
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true;
  
  environment.sessionVariables = {
      CUDA_PATH = "${pkgs.cudatoolkit}";
      EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
      EXTRA_CCFLAGS = "-I/usr/include";
      LD_LIBRARY_PATH = [
          "/usr/lib/wsl/lib"
          "${pkgs.linuxPackages.nvidia_x11}/lib"
          "${pkgs.ncurses5}/lib"
  ];
      MESA_D3D12_DEFAULT_ADAPTER_NAME = "Nvidia";
  };
  
  hardware.nvidia-container-toolkit = {
      enable = true;
      mount-nvidia-executables = false;
  };
  
  systemd.services = {
      nvidia-cdi-generator = {
          description = "Generate nvidia cdi";
          wantedBy = [ "docker.service" ];
          serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.nvidia-docker}/bin/nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml --nvidia-ctk-path=${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk";
          };
      };
  };
  
  virtualisation.docker = {
      daemon.settings.features.cdi = true;
      daemon.settings.cdi-spec-dirs = ["/etc/cdi"];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
