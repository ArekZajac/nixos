{ config, pkgs, lib, ... }:

let
  # Gruvbox Dark palette (reused across apps).
  gruvbox = {
    bg = "#282828";
    bg1 = "#3c3836";
    bg2 = "#504945";
    fg = "#ebdbb2";
    gray = "#a89984";
    red = "#cc241d";
    redBright = "#fb4934";
    green = "#98971a";
    greenBright = "#b8bb26";
    yellow = "#d79921";
    yellowBright = "#fabd2f";
    blue = "#458588";
    blueBright = "#83a598";
    purple = "#b16286";
    purpleBright = "#d3869b";
    aqua = "#689d6a";
    aquaBright = "#8ec07c";
    orange = "#fe8019";
  };
in
{
  home.username = "arek";
  home.homeDirectory = "/home/arek";
  home.stateVersion = "25.11";

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;

  # User applications & desktop utilities
  home.packages = with pkgs; [
    # Apps
    chromium
    discord
    spotify

    # Desktop utilities
    grim
    slurp
    satty            # screenshot annotation
    cliphist         # clipboard history
    brightnessctl
    playerctl
    pavucontrol      # GUI audio mixer
    networkmanagerapplet
    wl-clipboard

    # GUI basics
    nautilus         # file manager
    imv              # image viewer
    mpv              # video
    zathura          # pdf
    file-roller      # archives
    unzip
    p7zip

    # CLI niceties
    eza
    bat
    fastfetch
    btop
  ];

  # Niri
  xdg.configFile."niri/config.kdl".source = ./dotfiles/niri/config.kdl;

  # Terminal
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
        padding = { x = 8; y = 8; };
      };
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 11.0;
      };
      colors = {
        primary = {
          background = gruvbox.bg;
          foreground = gruvbox.fg;
        };
        normal = {
          black = gruvbox.bg;
          red = gruvbox.red;
          green = gruvbox.green;
          yellow = gruvbox.yellow;
          blue = gruvbox.blue;
          magenta = gruvbox.purple;
          cyan = gruvbox.aqua;
          white = gruvbox.gray;
        };
        bright = {
          black = gruvbox.gray;
          red = gruvbox.redBright;
          green = gruvbox.greenBright;
          yellow = gruvbox.yellowBright;
          blue = gruvbox.blueBright;
          magenta = gruvbox.purpleBright;
          cyan = gruvbox.aquaBright;
          white = gruvbox.fg;
        };
      };
    };
  };

  # Launcher
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        layer = "overlay";
        width = 35;
        prompt = "❯ ";
      };
      colors = {
        background = "282828f0";
        text = "ebdbb2ff";
        match = "fabd2fff";
        selection = "504945ff";
        selection-text = "ebdbb2ff";
        selection-match = "fabd2fff";
        border = "fe8019ff";
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };

  # Notifications
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 11";
      background-color = gruvbox.bg;
      text-color = gruvbox.fg;
      border-color = gruvbox.orange;
      border-size = 2;
      border-radius = 8;
      default-timeout = 5000;
      width = 360;
      height = 120;
      margin = "10";
      padding = "10";
    };
  };

  # Status bar
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      spacing = 6;
      modules-left = [ "niri/workspaces" "niri/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "cpu" "memory" "tray" ];

      "niri/workspaces" = {
        format = "{index}";
      };
      "niri/window" = {
        max-length = 60;
        format = "{title}";
      };
      clock = {
        format = "{:%a %d %b  %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };
      cpu = {
        format = " {usage}%";
        interval = 2;
      };
      memory = {
        format = " {percentage}%";
        interval = 2;
      };
      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = " muted";
        format-icons.default = [ "" "" "" ];
        on-click = "pavucontrol";
      };
      network = {
        format-wifi = "{essid} ";
        format-ethernet = " {ifname}";
        format-disconnected = " off";
        tooltip-format = "{ifname}: {ipaddr}";
      };
      tray = {
        spacing = 8;
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }
      window#waybar {
        background-color: ${gruvbox.bg};
        color: ${gruvbox.fg};
        border-bottom: 2px solid ${gruvbox.bg2};
      }
      #workspaces button {
        padding: 0 8px;
        color: ${gruvbox.gray};
        background: transparent;
      }
      #workspaces button.active {
        color: ${gruvbox.bg};
        background-color: ${gruvbox.orange};
      }
      #workspaces button:hover {
        background-color: ${gruvbox.bg2};
        color: ${gruvbox.fg};
      }
      #window { color: ${gruvbox.gray}; padding: 0 10px; }
      #clock { color: ${gruvbox.fg}; font-weight: bold; }
      #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 10px;
      }
      #pulseaudio { color: ${gruvbox.greenBright}; }
      #network    { color: ${gruvbox.blueBright}; }
      #cpu        { color: ${gruvbox.yellowBright}; }
      #memory     { color: ${gruvbox.purpleBright}; }
    '';
  };

  # Idle / lock
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
      {
        timeout = 600;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
    ];
  };

  # Shell + prompt
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "eza -lah --icons";
      ls = "eza --icons";
      cat = "bat";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#desktop";
      update = "nix flake update --flake ~/nixos";
    };
    history.size = 10000;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };

  programs.git = {
    enable = true;
    settings.user.name = "ArekZajac";
    settings.user.email = "arekzajac@outlook.com";
  };

  # Theming (GTK + cursor)
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  # Dark mode preference for GTK apps.
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
