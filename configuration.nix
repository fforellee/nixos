# fforelle nixos config file
{ config, pkgs, ... }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
  });
in
{
  imports =
    [ 
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

  environment.systemPackages = with pkgs; [
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
     home-manager
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
  #http
  services.httpd = {
    enable= true;
    enablePHP= true;
    adminAddr = "icaro.onofre.s@gmail.com";
  };
  #MySql
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  #Mongodb
  services.mongodb.enable = true;

  services.openssh.enable = true;
  services.emacs.enable = true;
  # Virtualizaiton configuration 
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  programs.dconf.enable = true;

  system.stateVersion = "21.11"; # Nixos installation version
}
