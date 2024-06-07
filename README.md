You know the drill

```sh
sudo nixos-rebuild switch --flake <directory>
```
> Tip: clone on /etc/nixos

> The users folder should be polluted with links to each user's home-manager config directory
> For example jhonatan's user is distributed across three files jhonatan.nix, jhonatan.flake.nix and jhonatan.dotfiles
> In this case jhonatan.nix is a hard link to /home/jhonatan/.config/home-manager/jhonatan.nix and so on.

> jhonatan.nix -> /home/jhonatan/.config/home-manager/jhonatan.nix

> jhonatan.flake.nix -> /home/jhonatan/.config/home-manager/flake.nix

> jhonatan.dotfiles -> /home/jhonatan/.config/home-manager/jhonatan.dotfiles

If you intend to do per-user updates run

```sh
home-manager switch
```

> Make sure that the current user has home-manager installed or run 

```sh
nix-shell -p home-manager
``` 