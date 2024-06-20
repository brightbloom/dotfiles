{ config, pkgs, lib, ... }:

let 
  work = false;

  base_imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./home-manager.nix
    ];
in
{

  # If I set `work` to true at the start of the file, import `work.nix`.
  imports = if work==true then base_imports ++ [ ./work.nix ] else base_imports;
  
  # Needed for Sway
  security.polkit.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.variables.EDITOR = "nvim";

  # Enable flakes systemwide
  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.blueman.enable = true;
  services.tailscale.enable = true;
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  hardware.bluetooth.enable = true;

  systemd.user.services.nvimserver = {
    enable = true;
    description = "nvimserver";
    path = with pkgs; [neovim bash git nodejs gcc unzip python3];
    serviceConfig = {
      ExecStart = ''${pkgs.bash}/bin/bash -c "${pkgs.neovim}/bin/nvim --headless --listen /home/lena/.nvimsocket"'';
      Restart = "always";
    };
    wantedBy =  ["graphical.target" ]; 
  };

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

  # kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

  

  # Normal Waybar doesn't currently support workspaces on Hyprland; set the experimental flag
  # nixpkgs.overlays = [
  #   (self: super: {
  #     waybar = super.waybar.overrideAttrs (oldAttrs: {
  #       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  #     });
  #   })
  # ];

  programs = {
    light.enable = true;
    # enable sway window manager
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    neovim = {
      enable = true;
      vimAlias = true;
    };
    zsh.enable = true;
    # hyprland.enable = true;
    # hyprland.xwayland.enable = true;
    nix-ld.enable = true;
    dconf.enable = true;
    wireshark.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "luna"; # Define your hostname.

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";
  
  # Use 
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "DroidSansMono" "UbuntuMono" "Noto" "Agave" ]; })
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;                      # Windowing system
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.gdm.enable = true;   # Login manager
  security.pam.services.gdm.enableGnomeKeyring = true;   # Login manager
  # services.xserver.desktopManager.gnome.enable = true; # Just in case...

  # Make XDG apps launch better under Wayland
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland # btw, this portal also works great with sway
        xdg-desktop-portal-gtk
      ];
    };
  };

  virtualisation = {
    virtualbox.host.enable = true;
    virtualbox.host.enableExtensionPack = true;
    podman = {
      enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns.enable = true;
    };
    docker.enable=true;
    libvirtd.enable=true;
  };

  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable MDNS (needed for printing to Bonjour-enabled endpoints)
  services.avahi = {
    nssmdns = true;
    enable = true;
    ipv4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # Enable sound; Pipewire required for WebRTC, incl. Zoom screen sharing in Wayland
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support
  services.xserver.libinput.enable = true;

  # Define a user account
  users.users.lena = {
    isNormalUser = true;
	extraGroups = [ "wheel" "docker"  "dialout" "wireshark" "libvirt" "libvirtd" "vboxusers" ]; # "wheel" is for enabling sudo
    shell = pkgs.zsh;
  };

  # Use Ozone where possible
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Needed to get some openssh libexec binaries for Vagrant
  environment.pathsToLink = ["/libexec"];
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    binutils # for ar
    file
    pciutils # for lspci
    python3Full
    python311Packages.pip
    jq
    gcc
    lldb
    git
    firefox-wayland
    fuzzel
    lazygit
    neovim
    neovide
    bluez # bluetooth support
    unzip
    nodejs # for nvim's bashls
    cargo # for rust-analyzer, etc
    rustc # for rust-analyzer, etc
    rustup
    wireshark
    rust-analyzer
    discord
    kitty
    easyeffects
    usbutils
    wget
    screen
    # obsidian
    ripgrep
    wofi # dmenu replacement
    sway
    sway-contrib.grimshot
    swaylock
    waybar
    grim
    slurp
    tealdeer # moar better tldr
    sutils
    wl-clipboard
    zoom-us
    tmux
    qt6.qtwayland # dont remember why I needed this?
    killall
    spotify
    hyprpaper # background
    delta # git pager
    _1password
    _1password-gui
    fprintd-tod
    gcc-arm-embedded-9
    wireguard-tools
    wlr-randr # control monitors with cli
    nixfmt
    mercurial
    wally-cli # flash ZSA keyboards
    ungoogled-chromium
    dunst # notifications
    zathura # PDF viewer
    libvirt
    fuse
    appimage-run
    gparted
    bottles
    obs-studio
    vagrant
    rpi-imager
    xorg.libxcb.dev
    magic-wormhole
    pavucontrol
    gnupg
    linuxsampler
    fzf
    qsampler
    notion-app-enhanced
    stlink
    kicad
    conda
    gimp
    xorg.libXext
    udev
    stm32cubemx
    saleae-logic-2
    fd
    pkg-config
    libreoffice
    parallel
    openvpn3
    remmina
    signal-desktop
    fuzzel
    neovide
    units
    ddccontrol
    i2c-tools
    ddccontrol-db
    bambu-studio
    nix-index
    slack
    openssl.dev
    ansible
    libsecret
    nebula
    darktable
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;

  # Minimal configuration for NFS support with Vagrant.
  services.nfs.server.enable = true;
  # Add firewall exception for libvirt provider when using NFSv4 
  networking.firewall.interfaces."virbr1" = {                                   
    allowedTCPPorts = [ 2049 ];                                               
    allowedUDPPorts = [ 2049 ];                                               
  };     
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.dbus.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

