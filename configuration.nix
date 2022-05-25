# fforelle nixos config file
{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
  });

  myPhp = pkgs.php.buildEnv {
    extensions = { all, ... }: with all; [ sqlsrv pdo_sqlsrv ];
    extraConfig = "memory_limit=256M";
  };
  #home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";

in
{
  imports =
    [ 
      (import "${home-manager}/nixos")
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;      # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true; # Use the systemd-boot EFI boot loader.
  networking.hostName = "fforelle";     # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  time.timeZone = "America/SaoPaulo"; # Set your time zone.


  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  
  services.xserver.enable = true; # Enable the X11 windowing system.
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.startx.enable = true;

  fonts.fonts = with pkgs; [
		nerdfonts
	];
  services.xserver = {
    layout = "us,br";
    xkbOptions = "grp:win_space_toggle";
  };

  
  sound.enable = true;  # Enable sound.
  hardware.pulseaudio.enable = true;

  users.defaultUserShell = pkgs.zsh;
  
  #Allow unfree packages 
  nixpkgs.config = {
    allowUnfree = true;
  };

  #Home manager
   # home-manager.users.fforelle = {
   #   home.packages = [
   #    pkgs.fzf
   #    pkgs.neovim 
   #    pkgs.vim 
   #    pkgs.wget
   #    pkgs.firefox
   #    pkgs.emacs
   #    pkgs.i3
   #    pkgs.alacritty
   #    pkgs.zsh
   #    pkgs.virtmanager
   #    pkgs.qemu
   #    pkgs.qemu-system-gui
   #    pkgs.OVMF
   #    pkgs.zathura
   #    pkgs.libvirt
   #    pkgs.gimp
   #    pkgs.git
   #    pkgs.tcpdump
   #    pkgs.tmux
   #    pkgs.pavucontrol
   #    pkgs.virt-manager
   #    pkgs.virt-viewer
   #    pkgs.krita
   #    pkgs.gimp
   #    pkgs.ghc
   #    pkgs.python
   #    pkgs.discord
   #    pkgs.cabal-install
   #    pkgs.sqlite
   #    pkgs.python.pkgs.pip
   #    pkgs.youtube-dl
   #    pkgs.docker
   #    pkgs.polybar
   #    pkgs.php
   #    pkgs.wireshark
   #    pkgs.tex
   #    pkgs.nmap
   #    pkgs.polybar
   #    pkgs.gcc
   #    pkgs.colorls
   #    pkgs.stdenv
   #    pkgs.gnumake
   #    ];
   # };

  #Packages
  environment.systemPackages = with pkgs;
    [
      neovim 
      vim 
      wget
      firefox
      emacs
      i3
      alacritty
      zsh
      virtmanager
      qemu
      # qemu-system-gui
      OVMF
      zathura
      libvirt
      gimp
      git
      tcpdump
      tmux
      pavucontrol
      virt-manager
      virt-viewer
      krita
      gimp
      ghc
      python
      discord
      cabal-install
      sqlite
      python.pkgs.pip
      youtube-dl
      docker
      polybar
      php
      wireshark
      tex
      nmap
      polybar
      gcc
      colorls
      stdenv
      gnumake
    ];
    # User specific configurations
    users.users.fforelle = {
    isNormalUser = true;
    initialPassword = "asdf";
    extraGroups = [ "wheel" "libvirtd" ]; 
  };

  environment.variables.EDITOR = "nvim";
  nixpkgs.overlays = [
    (self: super: {
      neovim = super.neovim.override {
        viAlias = true;
        vimAlias = true;
      };
    })
  ];

  programs.ssh.askPassword = "";

  # Enable services
  #php

  services.phpfpm.phpOptions = ''
    extension=${pkgs.phpPackages.pdo_sqlsrv}/development/php-packages/pdo_sqlsrv
  '';

  #http
  services.httpd =
    {
      user = "fforelle";
      enable = true;
      adminAddr = "icaro.onofre.s@gmail.com";

      extraModules =
        [
          "http2"
        ];
      enablePHP = true;

      virtualHosts =
        {
          localhost = {
            documentRoot = "/home/fadhli/www";
          };
        };
    };

  #MySql
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  #Mongodb
  services.mongodb.enable = true;
  #Tor service
  services.tor.tsocks.enable = true;
  services.tor.enable = true;
  services.tor.client.enable = true;
  services.openssh.enable = true;
  services.emacs.enable = true;
  # Virtualizaiton configuration 
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;

  # virtualisation.libvirtd.qemu.verbatimConfig = ''
  #       /dev/null 
  #       /dev/full 
  #       /dev/zero 
  #       /dev/random
  #       /dev/urandom 
  #       /dev/ptmx 
  #       /dev/kvm 
  #       /dev/kqemu 
  #       /dev/rtc
  #       /dev/hpet
  #       /dev/input/by-id/usb-Logitech_G403_Prodigy_Gaming_Mouse_108138673138-event-mouse 
  #       /dev/input/by-id/usb-Logitech_G413_Carbon_Mechanical_Gaming_Keyboard_168137503432-event-kbd
  #   '';
    
  programs.dconf.enable = true;
  system.stateVersion = "21.11"; # Nixos installation version
}
