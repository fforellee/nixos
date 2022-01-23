# fforelle nixos config file
{ config, pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;      # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true; # Use the systemd-boot EFI boot loader.
  networking.hostName = "fforelle";     # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  time.timeZone = "Europe/Amsterdam"; # Set your time zone.

  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;

  
  services.xserver.enable = true; # Enable the X11 windowing system.
  services.xserver.videoDrivers = [ "modesetting" ];
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.startx.enable = true;

  fonts.fonts = with pkgs; [
		nerdfonts
	      ];

  
  sound.enable = true;  # Enable sound.
  hardware.pulseaudio.enable = true;
  
  environment.shells = [ pkgs.zsh ];

  environment.systemPackages = with pkgs; [
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
   ];

  # User specific configurations
  users.users.fforelle = {
     isNormalUser = true;
     initialPassword = "asdf";
     extraGroups = [ "wheel" ]; 
   };

  programs.ssh.askPassword = "";

  # Enable services
  services.openssh.enable = true;
  services.emacs.enable = true;

  system.stateVersion = "21.11"; # Nixos installation version
}
