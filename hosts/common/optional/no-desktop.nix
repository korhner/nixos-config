{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    desktopManager = {
      default = "none";
      xterm.enable = false;
    };
    displayManager = {
      lightdm.enable = true;
    };
  };
}
