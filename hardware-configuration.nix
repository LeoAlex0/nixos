# Set some hardware-specific configuration
{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Use the lanzaboote boot loader support secure boot.
  boot.loader.systemd-boot = {
    enable = lib.mkForce false;
    editor = false; # For security reason
    configurationLimit = 2; # Small EFI
  };
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.systemd.enable = true;

  boot.kernelModules = [ "kvm-intel" ];
  # boot.kernelParams = [
  #   # graphics
  #   "i915.force_probe=!7d55"
  #   "xe.force_probe=7d55"
  # ];
  boot.kernelPackages = pkgs.linuxPackages_latest; # use latest kernel waiting for firmware.
  # Sound: https://github.com/thesofproject/linux/issues/4973
  boot.extraModprobeConfig = ''
    options snd_sof_intel_hda_common sof_use_tplg_nhlt=1
    options snd_sof_pci tplg_filename=sof-hda-generic-ace1-4ch.tplg
  '';
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices = {
    cryptoroot = {
      device = "/dev/disk/by-uuid/8ec13f67-f402-4417-86a0-763edac997f9";
      allowDiscards = true; # Used if primary device is a SSD
      preLVM = true;
      crypttabExtraOpts = [ "tpm-device=auto" ];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bee06f5c-cfda-4816-a514-5a923dcf87dc";
    fsType = "ext4";
  };
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/E848-FC94";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 38 * 1024; # 48 GB
    }
  ];

  # Basic hardware
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Thunderbolt
  services.hardware.bolt.enable = true;

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # For wine application support

    extraPackages = with pkgs; [
      # Quick Sync Video
      vpl-gpu-rt

      # Accelerated Video Playback
      intel-media-driver
      libvdpau-va-gl

      # OpenCL
      intel-compute-runtime
    ];
  };

  # Camera (placeholder)
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6epmtl";
  };

  # Fingerprint Scanner (placeholder)
  services.fprintd.enable = true;
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
