{ lib, inputs, config, pkgs, ... }: {

  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
      eval "$(direnv hook bash)" 
      '';
    };

    home-manager.enable = true;
    git.enable = true;
    htop.enable = true;
    vim.enable = true;
    direnv.enable = true;
    rofi.enable = true;
    google-chrome.enable = true;
    
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-python.python
        mkhl.direnv
      ];
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";


  home = {
    username = lib.mkDefault "ivank";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";
    sessionPath = [ "$HOME/.local/bin" ];

    packages = with pkgs; [
      slack
      google-cloud-sdk
    ];

    persistence = {
      "/persist/home/ivank" = {
        directories = [
           "repositories"
           ".ssh"
           ".cache"
           ".config/Slack"
           ".config/google-chrome"
           ".config/gcloud"
           ".local/share/direnv/allow"
#          "Documents"
#          "Downloads"
#          "Pictures"
#          "Videos"
#          ".local/bin"
        ];
        files = [
          ".bash_history"
        ];
        allowOther = true;
      };
    };
  };

#  home-manager.users.ivank = {
#    #  ------   -----   ------
#    # | DP-3 | | DP-1| | DP-2 |
#    #  ------   -----   ------
#    #  monitors = [
#    #    {
#    #      name = "DP-3";
#    #      width = 1920;
#    #      height = 1080;
#    #      noBar = true;
#    #      x = 0;
#    #      workspace = "3";
#    #      enabled = false;
#    #    }
#    #    {
#    #      name = "DP-1";
#    #      width = 2560;
#    #      height = 1080;
#    #      refreshRate = 75;
#    #      x = 1920;
#    #      workspace = "1";
#    #    }
#    #    {
#    #      name = "DP-2";
#    #      width = 1920;
#    #      height = 1080;
#    #      noBar = true;
#    #      x = 4480;
#    #      workspace = "2";
#    #    }
#    #  ]
#  };

}
