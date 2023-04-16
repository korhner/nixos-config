{ config, lib, inputs, pkgs, modulesPath, isIso, ... }:
let
  # Utility to save a snapshot of the root tree
  save-root = pkgs.writers.writeDashBin "save-root" ''
    ${pkgs.findutils}/bin/find \
      / -xdev \( -path /tmp -o -path /var/tmp -o -path /var/log/journal \) \
      -prune -false -o -print0 | sort -z | tr '\0' '\n' > "$1"
  '';

  # Utility to compare the root tree
  diff-root = pkgs.writers.writeDashBin "diff-root" ''
    export PATH=${with pkgs; lib.makeBinPath [ diffutils less ]}:$PATH
    current="$(mktemp current-root.XXX --tmpdir)"
    trap 'rm "$current"' EXIT INT HUP
    ${save-root}/bin/save-root "$current"
    diff -u /run/initial-root "$current" --color=always | ''${PAGER:-less -R}
  '';
in
{
  config = {

    environment.systemPackages = [
      diff-root
    ];

    systemd.services.save-root-snapshot = {
      description = "save a snapshot of the initial root tree";
      wantedBy = [ "sysinit.target" ];
      requires = [ "-.mount" ];
      after = [ "-.mount" ];
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      serviceConfig.ExecStart = ''${save-root}/bin/save-root /run/initial-root'';
    };

  };
}