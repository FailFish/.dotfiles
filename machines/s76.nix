{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./s76-disk-config.nix
    ./s76-hardware-configuration.nix
  ];

  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    useOSProber = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.noah = {
    isNormalUser = true;
    description = "noah";
    openssh.authorizedKeys.keys = [
      # TODO: Add OpenSSH key(s) here, if you plan on using SSH to connect
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxvfY93G6+OsoEUyWzNBfhgPx8c5H84qSEJ3CbC7YX3 noah@noahMBA"
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBuydnea67JVePf4Y9nAxu+G/fwIJxyAkAAt3QWNoha noah@admin"
    ];
    group = "noah";
    extraGroups = [ "video" "wheel" ];
    shell = pkgs.bashInteractive;
    packages = with pkgs; [];
  };
  users.groups.noah = {};

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # key only
      PermitRootLogin = "no";
    };
  };

  networking = {
    hostName = "taehyun";
    interfaces = {
      enp3s0 = {
        ipv4 = {
          addresses = [
            {
              address = "128.83.143.95";
              prefixLength = 22;
            }
          ];
        };
      };
    };
    defaultGateway = {
      address = "128.83.143.1";
      interface = "enp3s0";
    };
    nameservers = [ "128.83.120.181" "128.83.120.30" ];
  };
  networking.wireless = {
    enable = true;
    # TODO: Secrets are now handled by the `networking.wireless.secretsFile` and
    # `networking.wireless.networks.<name>.pskRaw` options.
    # environmentFile = "/home/taehyun/wireless.env";
    userControlled.enable = true;

    networks = {
    };
  };
  # I found systemd.link's WOL does not work on wireless interfaces.
  # networking.interfaces.wlo1.wakeOnLan.enable = true;

  # Set your time zone.
  time.timeZone = "US/Central";

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
      nerd-fonts.roboto-mono
      nerd-fonts.jetbrains-mono
      material-design-icons
      nanum

      # Xorg defaults
      noto-fonts
      noto-fonts-cjk-sans
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

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
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

  services.printing.enable = true;
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
    udev.packages = [ pkgs.gnome-settings-daemon ];
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
  # virtualisation.containers.cdi.dynamic.nvidia.enable = true;
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };

  system.stateVersion = "24.05";
}
