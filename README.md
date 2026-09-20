# Exiled Exchange 2 Nix flake

Nix packaging for [Exiled Exchange 2](https://github.com/Kvan7/Exiled-Exchange-2).

## Requirements

- Nix with flakes enabled
- An `x86_64-linux` system

The package forces Electron to use XWayland. This prevents the overlay from taking keyboard focus away from PoE 2 under Wayland compositors such as Hyprland.

## NixOS flake configuration

Add this repository as an input:

```nix
{
  inputs.exiled-exchange-2.url = "github:rhermens/exiled-exchange-2-flake";
}
```

Then add the package to your system packages:

```nix
{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.exiled-exchange-2.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
```
