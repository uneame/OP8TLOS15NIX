{
  description = "Athakara: Nix-on-Droid system config.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-on-droid }: 
    let
      system = "aarch64-linux";

      pkgsUnstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      yt-dlp-overlay = final: prev: {
        yt-dlp = pkgsUnstable.yt-dlp;
      };

      ollama-overlay = final: prev: {
        ollama = pkgsUnstable.ollama;
      };

 
      pkgsWithOverlay = import nixpkgs {
        inherit system;
        overlays = [ 
          yt-dlp-overlay
          ollama-overlay
        ];
        config.allowUnfree = true;
      };

    in {
      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = pkgsWithOverlay;
        modules = [ ./nix-on-droid.nix ];
      };
    };
}
