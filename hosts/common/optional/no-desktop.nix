{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    desktopManager = {
      default = "none";
      xterm.enable = false;
      lightdm.enable = true;
    };
  };
}
