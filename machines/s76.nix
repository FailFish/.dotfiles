{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./s76-disk-config.nix
  ];

  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    useOSProber = true;
    # disko will add devices
    # device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.taehyun = {
    isNormalUser = true;
    description = "taehyun";
    openssh.authorizedKeys.keys = [
      # TODO: Add OpenSSH key(s) here, if you plan on using SSH to connect
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxvfY93G6+OsoEUyWzNBfhgPx8c5H84qSEJ3CbC7YX3 noah@noahMBA"
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBuydnea67JVePf4Y9nAxu+G/fwIJxyAkAAt3QWNoha noah@admin"
    ];
    extraGroups = [ "video" "wheel" ];
    shell = pkgs.bashInteractive;
    packages = with pkgs; [];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # key only
      PermitRootLogin = "no";
    };
  };

  networking.hostName = "taehyun";
  networking.wireless = {
    enable = true;
    environmentFile = "/home/taehyun/wireless.env";
    userControlled.enable = true;

    networks = {
      # KT_GiGA_5G_89B3 = {
      #   psk = "@PSK_HOMEKT@";
      # };
      # SKKU.auth = ''
      #   ssid="SKKU"
      #   eap=TTLS
      #   identity="dove0255@skku.edu"
      #   password="@PSK_SKKU_PUBLIC@"
      #   phase2="auth=PAP"
      # '';
    };
  };
  # I found systemd.link's WOL does not work on wireless interfaces.
  # networking.interfaces.wlo1.wakeOnLan.enable = true;

  # Set your time zone.
  time.timeZone = "US/Austin";

  # Select internationalisation properties.

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  services.logind = {
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [
          "*"
          "-1d50:615e"
        ];
        settings = {
          main = {
            capslock = "esc";
            leftmeta = "layer(alt)";
            leftalt = "layer(meta)";
          };
        };
      };
    };
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # https://nixos.wiki/wiki/Fonts
      (nerdfonts.override { fonts = [ "RobotoMono" "JetBrainsMono" ]; })
      material-design-icons
      nanum

      # Xorg defaults
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Noto Sans" "Source Han Sans" ];
    };
  };

  # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
  nixpkgs = {
    overlays = [
      # https://github.com/nixos/nixpkgs/issues/157101
      (final: prev: {
        waybar = prev.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      })
    ];
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

  security.pam.services.swaylock.text = ''
    auth include login
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
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git

    # wayland specific
    wl-clipboard
    wev

    brightnessctl
    flameshot
    firefox
    brave
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
  };

  services = {
    dbus.packages = [ pkgs.gcr ];
    udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # other XDPs cause conflict with hyprland
    ];
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # This option will expose GPUs on containers with the `--device` CLI option.
  # supported by Docker >= 25, Podman >= 3.2.0
  virtualisation.containers.cdi.dynamic.nvidia.enable = true;
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };

  system.stateVersion = "24.05";
}
