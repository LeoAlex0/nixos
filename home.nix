{ pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in {
  imports = [
    (import "${home-manager}/nixos")
  ];
  
  home-manager.users.leo = {
    nixpkgs.config.allowUnfree = true;
    home.stateVersion = "22.05";
    home.language.base = "zh_CN.UTF-8";
    home.packages = with pkgs; [
      # Daily
      thunderbird rnix-lsp

      # Art
      krita

      # Code
      clang
      cargo rustc
      go
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
    };
  };
}
