{ pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.homeDirectory = "/data/data/com.termux.nix/files/home";

  home.sessionVariables = {
    EDITOR = "nvim";  
    VISUAL = "nvim";  
    PAGER = "less";  
    #TERMINAL = "tmux";  
    MANPAGER = "nvim +Man!";  
    LANG = "fr_FR.UTF-8";  
    #LC_ALL = "fr_FR.UTF-8";
    LESS = "-R -F";  
    LESSHISTFILE = "-";
  };


  home.packages = with pkgs; [
    neofetch
    git
    #ripgrep
    jq
    nixfmt
    typst
    pandoc
  ];

  programs.git = {
    enable = true;
    userName = "uneame";
    userEmail = "camarade042@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
  

  programs.fish = {  
    enable = true;  
    shellAliases = {  
      ls = "command ls --color=auto";
      ll = "ls -la --color=auto";  
      cls = "clear";

      yt-audio = "yt-dlp --format 249 --console-title";
      yt-video = "yt-dlp --format 18 --console-title";
      yt-list = "yt-dlp -F";

      cat = "bat --color=auto --number";
      less = "less --use-color";
      grep = "rg";

      nix-shell = "nix-shell --command fish";

      upgrade = "nix flake update ~/.config/nix-on-droid --verbose";
      update = "nix-on-droid switch --flake ~/.config/nix-on-droid";
      cleanup = "nix-collect-garbage -d";
    };  

    # fish_vi_key_bindings = {
    #   enable = true;
    #   no-erase = false;
    # };
    
    #abbreviations = {  
    #  g = "git";  
    #  v = "nvim";  
    #  h = "helix";  

    #  gst = "git status";                                 
    #  gco = "git checkout";
    #  gb = "git branch";
    #  ga = "git add";
    #  gc = "git commit";
    #  gd = "git diff";
    #};

    #plugins = with pkgs; [  
    #  (fishPlugins.fzf) 
    #  (fishPlugins.zoxide) 
    #];

    functions = {  
      transfert_conf = ''
        set MY_SOURCES_DIR $HOME/.config/nix-on-droid
        set MY_DEST_DIR $HOME/storage/documents/NixConf
        set MY_FILES "flake.nix" "nix-on-droid.nix" "home.nix" "authorized_keys.pub" "ollama-key.env"
        
        if ! test -d $MY_DEST_DIR
          mkdir $MY_DEST_DIR
        end

        for i in $MY_FILES
          cp -f $MY_SOURCES_DIR/$i $MY_DEST_DIR/$i
        end
      '';
    };

    shellInit = ''
      set -g history_ignore_dups
      #set -gx PATH $PATH ~/.local/bin
    '';

    interactiveShellInit = ''  
      set -g fish_greeting
      set -g fish_key_bindings fish_vi_key_bindings
      if test -f ~/.config/nix-on-droid/ollama-key.env
        set -gx OLLAMA_API_KEY (cat ~/.config/nix-on-droid/ollama-key.env)
      end
    '';

  };

  programs.starship = {  
    enable = true;  
      
    enableFishIntegration = true;  
      
    settings = {  
      add_newline = true;  
      command_timeout = 500;  
      # Personnalisation du prompt  
      #prompt_order = [  
      #  "username"  
      #  "hostname"  
      #  "directory"  
      #  "git_branch"  
      #  "git_state"  
      #  "git_status"  
      #  "rust"  
      #  "nodejs"  
      #  "python"  
      #  "nix_shell"  
      #  "cmd_duration"  
      #  "line_break"  
      #  "jobs"  
      #  "battery"  
      #  "character"  
      #];  
        
      # Caractère principal  
      character = {  
        success_symbol = "[➜](bold%20green)";  
        error_symbol = "[➜](bold%20red)";  
      };  
        
      # Dossier  
      directory = {  
        truncate_to_repo = false;  
        truncation_length = 3;  
        style = "cyan bold";  
      };  
        
      # Branche Git  
      git_branch = {  
        symbol = "🌱 ";  
        style = "yellow bold";  
        format = "on [\$symbol\$branch](\$style) ";  
      };  
        
      # Statut Git  
      git_status = {  
        format = "([\$all_status\$ahead_behind](\$style) )";  
        style = "yellow bold";  
        conflicted = "🏴";  
        ahead = "⇡\${count}";  
        behind = "⇣\${count}";  
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";  
        untracked = "?";  
        stashed = "📦";  
        modified = "!";  
        staged = "+";  
        renamed = "»";  
        deleted = "✘";  
      };  
        
      # Durée de la commande  
      cmd_duration = {  
        style = "bold yellow";  
        show_milliseconds = false;  
        min_time = 2000;  
      };  
        
      # Environnement Nix  
      nix_shell = {  
        format = "via [\$symbol\$state](\$style) ";  
        symbol = "❄️ ";  
        style = "blue bold";  
      };  
        
      # Python  
      python = {  
        format = "via [\${symbol}\${pyenv_prefix}(\${version} )](\$style)";  
        symbol = "🐍 ";  
        style = "yellow bold";  
      };  
        
      # Rust  
      rust = {  
        format = "via [\$symbol\$version](\$style) ";  
        symbol = "🦀 ";  
        style = "red bold";  
      };  
    };  
  };

  programs.neovim = {  
    enable = true;  
    defaultEditor = true;  
    viAlias = true;  
    vimAlias = true;  
    plugins = with pkgs.vimPlugins; [  
      vim-nix  
      vim-surround  
      vim-commentary  
      vim-fugitive  
      telescope-nvim  
      nvim-lspconfig  
    ];  
    extraConfig = ''  
      set number  
      syntax on  
    '';
  };  

  programs.fzf = {  
    enable = true;  
    enableFishIntegration = true;  
    defaultCommand = "fd --type f";  
    defaultOptions = [  
      "--height 40%"  
      "--layout=reverse"  
      "--border"  
      "--preview 'bat --style=numbers --color=always {}'"  
    ];  
    changeDirWidgetCommand = "fd --type d";  
    changeDirWidgetOptions = [ "--preview 'exa --tree --color=always {} | head -200'" ];  
    fileWidgetCommand = "fd --type f";  
  };

  programs.zoxide = {  
    enable = true;  
    enableFishIntegration = true;  
    options = [ "--cmd cd" ];  
  };

  programs.bat = {  
    enable = true;  
    config = {  
      theme = "Monokai Extended Origin";
      style = "numbers,changes,header";  
      paging = "never";  
    };  
  };

  programs.helix = {  
    enable = true;  
    defaultEditor = false;  
      
    settings = {  
      theme = "catppuccin_macchiato";
      /*
      fish_vi_key_bindings = {
        enable = true;
        no-erase = false;
      };
      */
      editor = {  
        line-number = "relative";  
        mouse = true;  
        cursor-shape = {  
          insert = "bar";  
          normal = "block";  
          select = "underline";  
        };  
        file-picker = {  
          hidden = false;  
          git-ignore = true;  
        };  
        statusline = {  
          left = [ "mode" "spinner" "file-name" ];  
          right = [ "total-line-numbers" "selections" "register" "position-percentage" ];  
        };  
      };  
    };  
      
    languages = {  
      language = [  
        {  
          name = "rust";  
          auto-format = true;  
          formatter = { command = "rustfmt"; args = [ "--edition" "2021" ]; };  
        }  
        {  
          name = "nix";  
          formatter = { command = "nixfmt-classic"; };  
        }  
        {  
          name = "python";  
          formatter = { command = "black"; };  
        }  
      ];  
    };  
      
  };

  programs.direnv = {  
    enable = true;  
    nix-direnv.enable = true;  
    #enableFishIntegration = true;  
    config = {  
      global = {  
        load_dotenv = true;  
        strict_env = true;  
      };  
    };  
  };

  home.file."transfert_conf.txt".text = ''
      set MY_SOURCES_DIR $HOME/.config/nix-on-droid
      set MY_DEST_DIR $HOME/storage/documents/NixConf
      set MY_FILES "flake.nix" "nix-on-droid.nix" "home.nix"
  '';

}
