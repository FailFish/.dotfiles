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

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "kime";
    };
  };

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  services.keyd = {
    enable = true;
    settings = {
      main = {
        capslock = "esc";
        leftmeta = "layer(alt)";
        leftalt = "layer(meta)";
      };
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      # https://nixos.wiki/wiki/Fonts
      (nerdfonts.override { fonts = [ "RobotoMono" "JetBrainsMono" ]; })
      font-awesome
      material-design-icons
      nanum
    ];
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Non-privileged users reboot/poweroff
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';

  # authentication agent config from https://nixos.wiki/wiki/Polkit
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  environment.shells = [ pkgs.bashInteractive ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git

    # wayland specific
    wl-clipboard
    swaybg
    wofi
    mako
    wlogout # powermenu

    flameshot
    firefox
    nyxt
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # key only
      PermitRootLogin = "no";
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  programs.waybar.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = false;
    };
    nvidiaPatches = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # other XDPs cause conflict with hyprland
    ];
  };

  system.stateVersion = "23.05";
}
