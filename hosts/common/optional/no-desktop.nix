{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    desktopManager = {
      default = "none";
      xterm.enable = false;
    };
    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };
    windowManager = {
      i3.enable = true;
    };
  };
}
