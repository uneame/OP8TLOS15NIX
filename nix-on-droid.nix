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

    openssh
    (writeScriptBin "sshd-start" ''
      #!${runtimeShell}
      echo "Starting sshd on port 8022"
      ${openssh}/bin/sshd -f "${config.user.home}/sshd/sshd_config" -D
    '')
  ];

  # --- Configuration SSH (sshd) ---
  # 1. Place ta clé publique dans le même dossier que ce fichier,
  #    sous le nom "authorized_keys.pub" (ou change le chemin ci-dessous).
  # 2. Après "nix-on-droid switch", lance "sshd-start" pour démarrer le serveur.
  build.activation.sshd =
    let
      sshdTmpDirectory = "${config.user.home}/sshd-tmp";
      sshdDirectory = "${config.user.home}/sshd";
      pathToPubKey = ./authorized_keys.pub;
    in
    ''
      $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${config.user.home}/.ssh"
      $DRY_RUN_CMD cat ${pathToPubKey} > "${config.user.home}/.ssh/authorized_keys"

      if [[ ! -d "${sshdDirectory}" ]]; then
        $DRY_RUN_CMD rm $VERBOSE_ARG --recursive --force "${sshdTmpDirectory}"
        $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${sshdTmpDirectory}"

        $VERBOSE_ECHO "Generating host keys..."
        $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t rsa -b 4096 -f "${sshdTmpDirectory}/ssh_host_rsa_key" -N ""

        $VERBOSE_ECHO "Writing sshd_config..."
        $DRY_RUN_CMD echo -e "HostKey ${sshdDirectory}/ssh_host_rsa_key\nPort 8022\n" > "${sshdTmpDirectory}/sshd_config"

        $DRY_RUN_CMD mv $VERBOSE_ARG "${sshdTmpDirectory}" "${sshdDirectory}"
      fi
    '';

  android-integration = {
    am.enable = true;
    termux-open.enable = true;
    termux-open-url.enable = true;
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
    xdg-open.enable = true;
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

