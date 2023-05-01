{ lib, inputs, config, pkgs, ... }: {

  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  programs = {
    home-manager.enable = true;
    git.enable = true;
    htop.enable = true;
    vim.enable = true;
    direnv.enable = true;
    firefox.enable = true;

    i3status-rust = {
      enable = true;
      bars.tepid = {
        icons = "awesome5";
        theme = "native";
        blocks = [
          {
            block = "focused_window";
          }
#          {
#            block = "net";
#            device = "enp59s0u2u4";
#          }
#          {
#            block = "weather";
#            service = {
#              name = "openweathermap";
#              inherit (secrets.openweathermap) api_key;
#              city_id = "2155416";
#              units = "metric";
#            };
#          }
          {
            block = "sound";
          }
          {
            block = "time";
            format = "%d/%m %R";
          }
        ];
      };
    };

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

    persistence = {
      "/persist/home/ivank" = {
        directories = [
           "repositories"
           ".ssh"
#          "Documents"
#          "Downloads"
#          "Pictures"
#          "Videos"
#          ".local/bin"
        ];
        files = [
          ".local/share/fish/fish_history"
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
