## Rebuilding the system
```
sudo nixos-rebuild switch --flake .
```

## Updating
TODO

## Impermanence
`sudo impermanence-diff`
When adding a new file/dir to impermanence, follow this steps:
- move the file to /persist. For example ~/repositories/nixos-config goes to /persist/home/ivank/repositories/nixos-config
- Add it to nix. System and home impermanence are separate configs
- Rebuild system

## Auth to github
```shell
cd /persist/home/ivank/.ssh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

## Easily clone all github repos
```shell
nix shell nixpkgs#ghorg
ghorg clone Algebra-AI --match-regex=^gametuner- --token=<github_access_token>
```

## Debugging the flake
```shell
nix repl
:lf .
outputs
```

## Testing on VM
- Create a linux 64bit VM (had problems with virtualbox, worked in vmware)
- Mount minimal iso install
- Find vmx file and make sure `firmware = "efi"` exists

# Get a shell with some applications
`nix shell nixpkgs#vim nixpkgs#htop`