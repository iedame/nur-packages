# Rafael Ieda's Nix User Repository

[![Build Status](https://github.com/iedame/nur-packages/workflows/Build%20and%20populate%20cache/badge.svg)](https://github.com/iedame/nur-packages)
[![Rafael Ieda's Cachix Cache](https://img.shields.io/badge/cachix-iedame-blue.svg)](https://iedame.cachix.org)

**My personal [NUR](https://github.com/nix-community/NUR) repository**, use it at your own risk.

## How to use

> **NOTE**: To follow the following usage, you need to have [Nix](https://nixos.org/nix/) installed with `flakes` & `new-comands` enabled first.

Run packages directly from this repository(no cache):

```sh
nix run github:iedame/nur-packages#some-package
```

Use this repository in `flake.nix`:

```nix
# flake.nix
{
  # the nixConfig here only affects the flake itself, not the system configuration!
  # for more information, see:
  #     https://nixos-and-flakes.thiscute.world/nixos-with-flakes/add-custom-cache-servers
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    extra-substituters = [ "https://iedame.cachix.org" ];
    extra-trusted-public-keys = [ "iedame.cachix.org-1:ULOEEwdkoANx+gj1//8s4DhstfTSipDWNKISwt5GUec=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur-iedame = {
      url = "github:iedame/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nur-iedame, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = with pkgs; [
            # Add packages from this repo
            nur-iedame.packages.${system}.some-package
          ];
        })
      ];
    };
  };
}
```

## Notes for myself

1. Add your packages to the [pkgs](./pkgs) directory and to
   [default.nix](./default.nix)
   * Remember to mark the broken packages as `broken = true;` in the `meta`
     attribute, or travis (and consequently caching) will fail!
   * Library functions, modules and overlays go in the respective directories
2. [Add yourself to NUR](https://github.com/nix-community/NUR#how-to-add-your-own-repository) if you want to share your packages.

## LICENSE

[MIT](./LICENSE)
