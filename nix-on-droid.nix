{ config, lib, pkgs, ... }:
{

  environment.packages = with pkgs; [
    ncurses
    procps
    #killall
    #diffutils
    #findutils
    #utillinux
    tzdata
    hostname
    man
    gnugrep
    #gnupg
    gnused

    gnutar
    bzip2
    gzip
    xz
    zip
    unzip
    python312
    nodejs_22
    uv
    ripgrep
    ffmpeg

    ollama
    yt-dlp

  ];

  android-integration = {
    #am.enable = true;
    #termux-open.enable = true;
    termux-open-url.enable = true;
    #termux-reload-settings.enable = true;
    #termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    #termux-wake-unlock.enable = true;
    #xdg-open.enable = true;
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "fish";
    BROWSER = "termux-open-url";
    OLLAMA_API_KEY = builtins.readFile ./ollama-key.env;
  };

  # Shell de connexion par défaut sur nix-on-droid
  user.shell = "${pkgs.fish}/bin/fish";

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  time.timeZone = "America/Cayenne";

  # Configuration du gestionnaire d'environnement Home-Manager
  home-manager.config = ./home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}

