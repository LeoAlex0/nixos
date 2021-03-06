# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    useOSProber = true;
    efiSupport = true;
    device = "nodev";
  };
  boot.supportedFilesystems = [ "nfs" "ntfs" "exfat" ];

  networking.hostName = "Leo-NSys"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
    };
  };

  # Fonts
  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      wqy_microhei
      wqy_zenhei
      fira-code
    ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enablePepperFlash = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Editor
    neovim

    # AppImage
    appimage-run
    
    # Misc
    psmisc
    axel git chromium
    # Input Methods
    fcitx fcitx-configtool libsForQt5.fcitx-qt5
    # Document-work
    lyx typora pandoc

    # Coding-work-libs
    opencv qt5.full
    
    # Coding-work-compiliers
    binutils gcc gdb stack idris go python37Full
    # Coding-work-tools
    cmake gnumake xclip ccls
    python37Packages.ipython python37Packages.pip
    android-studio jetbrains.idea-ultimate jetbrains.clion jetbrains.pycharm-professional jetbrains.jdk

    # Vim Plugins Depends
    nodejs yarn

    # Wine
    wine-staging winetricks
    
    # WireShark
    wireshark
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    light.enable = true;
    adb.enable = true;
    java.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true; 
      enableSSHSupport = true;
    };
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "python" "man" ];
        theme = "robbyrussell";
      };
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    dpi = 198;
  };

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leo = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "audio" "video" "disk" "cdrom" "users" "systemd-journal" "wireshark" ]; # Enable ‘sudo’ for the user.
    description = "zLeoAlex";
    shell = pkgs.zsh;
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = ["wheel"];
      }
    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
