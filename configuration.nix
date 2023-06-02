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
  hardware.bluetooth.enable = true;


  systemd.user.services.nvimserver = {
    enable = true;
    description = "nvimserver";
    path = with pkgs; [neovim bash git nodejs gcc unzip python3];
    serviceConfig = {
      ExecStart = ''${pkgs.bash}/bin/bash -c "${pkgs.neovim}/bin/nvim --headless --listen /tmp/nvimsocket"'';
      Restart = "always";
    };
    wantedBy =  ["multi-user.target" ]; 
  };


  
  # Normal Waybar doesn't currently support workspaces on Hyprland; set the experimental flag
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
    };
    zsh.enable = true;
    sway.enable = true;
    hyprland.enable = true;
    hyprland.xwayland.enable = true;
    hyprland.xwayland.hidpi = true;
    nix-ld.enable = true;
    dconf.enable = true;
    wireshark.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "brightbloom"; # Define your hostname.

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
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns.enable = true;
    };
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
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

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
  users.users.josh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "dialout" "wireshark" ]; # "wheel" is for enabling sudo
    shell = pkgs.zsh;
  };

  # Use Ozone where possible
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    _1password-gui
    binutils # for ar
    file
    pciutils # for lspci
    vim
    jq
    gcc
    git
    firefox-wayland
    fuzzel
    lazygit
    neovim
    neofetch
    neovide
    bluez
    unzip
    nodejs # for nvim's bashls
    cargo # for rust-analyzer, etc
    rustc # for rust-analyzer, etc
    rustup
    wireshark
    rust-analyzer
    wezterm
    kitty
    usbutils
    geekbench
    wget
    screen
    obsidian
    ripgrep
    wofi
    sway
    sway-contrib.grimshot
    swaylock
    waybar
    grim
    slurp
    tealdeer
    wl-clipboard
    zoom-us
    zellij
    qt6.qtwayland
    killall
    hyprpaper
    delta
    wlr-randr
    wally-cli
    dunst # notifications
    zathura
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.dbus.enable = true;

  # Open ports in the firewall.
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

