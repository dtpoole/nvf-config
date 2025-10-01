{
  config,
  lib,
  pkgs,
  osConfig ? null,
  inputs,
  ...
}: let
  cfg = config.programs.nvf-config;

  nvf = inputs.nvf-config.inputs.nvf or inputs.nvf;

  # Create the neovim package with the selected profile
  neovimPackage =
    (nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [(import ./nvf-config.nix {inherit (cfg) profile;})];
    }).neovim;

  isNixOS = config ? environment || osConfig != null;
  isHomeManager = !isNixOS;
in {
  options.programs.nvf-config = {
    enable = lib.mkEnableOption "nvf-config neovim configuration";

    profile = lib.mkOption {
      type = lib.types.enum ["base" "full"];
      default = "full";
      description = ''
        Which profile to use:
        - base: Basic editing without LSP
        - full: Complete setup with LSP and completion
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = neovimPackage;
      description = "The neovim package with nvf configuration";
    };

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = isHomeManager;
      description = "Set nvf-config neovim as the default editor";
    };

    withAliases = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install vi and vim aliases for neovim";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional configuration to append to init.lua";
    };

    systemWide = lib.mkOption {
      type = lib.types.bool;
      default = isNixOS && !isHomeManager;
      description = "Install neovim system-wide (NixOS only)";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    # NixOS system-wide configuration
    (lib.mkIf (isNixOS && cfg.systemWide) {
      environment.systemPackages = [cfg.package];

      environment = {
        variables = lib.mkIf cfg.defaultEditor {
          EDITOR = lib.mkDefault "nvim";
          VISUAL = lib.mkDefault "nvim";
        };
        shellAliases = lib.mkIf cfg.withAliases {
          vi = "nvim";
          vim = "nvim";
          vimdiff = "nvim -d";
        };
      };

      programs.neovim = {
        enable = true;
        inherit (cfg) package defaultEditor;
        viAlias = cfg.withAliases;
        vimAlias = cfg.withAliases;
      };
    })

    # Home Manager configuration (works both standalone and with NixOS)
    (lib.mkIf isHomeManager {
      home.packages = [cfg.package];

      home = {
        sessionVariables = lib.mkIf cfg.defaultEditor {
          EDITOR = "nvim";
          VISUAL = "nvim";
        };

        shellAliases = lib.mkIf cfg.withAliases {
          vi = "nvim";
          vim = "nvim";
          vimdiff = "nvim -d";
        };
      };
    })
  ]);
}
