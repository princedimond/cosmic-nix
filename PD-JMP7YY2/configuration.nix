# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "PD-JMP7YY2"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Enable the Cosmic Desktop Environment
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # define user princedimond
  users.users.princedimond = {
    isNormalUser = true;
    description = "princedimond";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbird
      thunderbolt
      #ventoy-full
      wine
      wine64
      wine-wayland
    ];
  };

  #define user guest
  users.users.guest = {
    isNormalUser = true;
    description = "guest";
    initialPassword = "guest";
    extraGroups = [
      "networkmanager"
      #"wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
      thunderbolt
    ];
  };
  
  # Install firefox.
  #programs.firefox.enable = true;

  # Install NPM and associated NPM packages
  programs.npm = {
    enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    microsoft-edge
    ferdium
    protonvpn-gui
    protonvpn-cli
    gitkraken
    github-desktop
    btop
    vscode
    bitwarden
    expressvpn
    onlyoffice-bin
    gitkraken
    direnv
    vlc
    deluge
    htop
    glances
    pro-office-calculator
    mission-center
    pkgs.gnome-disk-utility
    pkgs.python312
    orca-slicer
    fastfetch
    meld
    #node2nix
    nixd
    #helix
    helix-gpt
    nh
    apacheHttpd
    tailscale
    thunderbolt
    affine
    gthumb
    kdePackages.gwenview
    evil-helix
    xfce.thunar
    hplipWithPlugin
    hplip
    system-config-printer
    imagemagick
    graphicsmagick-imagemagick-compat
    gthumb
    discord
    flatpak
    inputs.zen-browser.packages.x86_64-linux.default
    inputs.zen-browser.packages.x86_64-linux.specific
    inputs.zen-browser.packages.x86_64-linux.generic
    inputs.nixvim.packages.x86_64-linux.default
  ];

# services.flatpak.packages = [
#    "com.microsoft.Edge"
#  ];

  #kernel options
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Nixvim vi Alias
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;

  # List services that you want to enable:
  services.expressvpn.enable = true;
  services.tailscale.enable = true;
  services.hardware.bolt.enable = true;
  services.flatpak.enable = true;

  # Enable Flakes
#  nix.settings.experimental-features = [
#    "nix-command"
#    "flakes"
#  ];

systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak install -y microsoft-edge
    '';
  };

# Enable Flakes & Cleanup
   nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      #substituters = [ "https://hyprland.cachix.org" ];
      #trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  #SystemD Stop Job Fix
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
    DefaultTimeoutStartSec=10s
  '';

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
