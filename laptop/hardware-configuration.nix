{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {

    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];

    # System76 support packages.
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ ];

    loader = {
       efi.canTouchEfiVariables = true;
       grub.device = "/dev/nvme0n1";
       # Use the systemd-boot EFI boot loader.
       systemd-boot.enable = true;
    };

    initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/2777d8ca-f68d-4697-b061-2e6d1cd0e0db";
  };

  hardware.system76.kernel-modules.enable = true;

  services.xserver.videoDrivers = ["intel"];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/396784cc-284c-44c7-9a57-59f408426fa8";
      fsType = "ext4";
    };


  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3DCE-D5BA";
      fsType = "vfat";
    };

  swapDevices = [ {device = "/dev/nvme0n1p4"; randomEncryption.enable = true;} ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s20f0u1u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s20f0u1u4u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp46s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
