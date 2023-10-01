{ pkgs
, ...
}:
{
  nixpkgs.config.allowUnfree = true;
  home.stateVersion = "22.05";
  home.language.base = "zh_CN.UTF-8";
  home.packages = with pkgs; [
    # Daily
    rnix-lsp
    nixpkgs-fmt
    tdesktop
    qgnomeplatform
    vlc
    gnomeExtensions.simple-system-monitor

    # Art
    krita

    # Code
    clang
    rustup
    go

    # Network
    v2raya
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

  programs.vscode.enable = true;
}
