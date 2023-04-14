{ pkgs, config, lib, outputs, ... }: {
  users.mutableUsers = false;
  users.users.ivank = {
    initialPassword = "qwe123";
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];

    packages = [ pkgs.home-manager ];
  };

    imports = [
      ./global
      # TODO add others
    ];

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