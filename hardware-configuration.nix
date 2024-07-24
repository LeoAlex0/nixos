# Set some hardware-specific configuration
{ pkgs
, lib
, config
, ...
}: {
  # Use the lanzaboote boot loader support secure boot.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "i915.force_probe=7d55" ]; # graphics
  boot.extraModulePackages = [ ];


  boot.initrd.luks.devices."luks-8ec13f67-f402-4417-86a0-763edac997f9".device = "/dev/disk/by-uuid/8ec13f67-f402-4417-86a0-763edac997f9";
  
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/bee06f5c-cfda-4816-a514-5a923dcf87dc";
      fsType = "ext4";
    };
  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/E848-FC94";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  swapDevices = [ ];

  # Basic hardware
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;   # For wine application support
    extraPackages = with pkgs; [
      vpl-gpu-rt
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}