{ pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  home-manager.users.leo = {
    nixpkgs.config.allowUnfree = true;
    home.stateVersion = "22.05";
    home.language.base = "zh_CN.UTF-8";
    home.packages = with pkgs; [
      # Daily
      rnix-lsp nixpkgs-fmt
      tdesktop qgnomeplatform vlc
      gnomeExtensions.simple-system-monitor

      # Art
      krita

      # Code
      clang
      rustup
      go

      # Network
      qv2ray
      v2ray
      v2ray-domain-list-community
      v2ray-geoip
    ];

    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "rust" "golang" ];
        theme = "robbyrussell";
      };
    };

    programs.firefox = {
      enable = true;
    };

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        ms-ceintl.vscode-language-pack-zh-hans 
        matklad.rust-analyzer
        jnoortheen.nix-ide
        arrterian.nix-env-selector
        ms-vscode-remote.remote-ssh
        yzhang.markdown-all-in-one
      ];
      userSettings = {
        "editor.cursorSmoothCaretAnimation" = true;
        "editor.smoothScrolling" = true;
        "workbench.list.smoothScrolling" = true;
        "editor.fontFamily" = "'Fira Code','Droid Sans Mono', 'Noto Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
        "[rust]" = {
          "editor.defaultFormatter" = "rust-lang.rust-analyzer";
        };
      };
    };
  };
}
