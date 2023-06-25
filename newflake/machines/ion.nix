# Galaxy Book Ion NT950XCR
{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./ion-hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ion";
  networking.wireless = {
    enable = true;
    userControlled.enable = true;

    networks = {
      KT_GiGA_5G_BC36 = {
        psk = "dzc60jz637";
      };
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

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

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  users.users.noah = {
    isNormalUser = true;
    description = "noah";
    openssh.authorizedKeys.keys = [
      # TODO: Add OpenSSH key(s) here, if you plan on using SSH to connect
    ];
    extraGroups = [ "wheel" ];
    shell = pkgs.bashInteractive;
    packages = with pkgs; [];
  };

  # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
  nixpkgs = {
    # vscode requires unfree
    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # key only
      PermitRootLogin = "no";
    };
  };

  system.stateVersion = "23.05";
}
