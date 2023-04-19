{ pkgs, ... }: {
  home.packages = with pkgs; [
    pkgs.xfce
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.xfce.enable = true;
}