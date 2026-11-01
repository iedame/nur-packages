# The repository's contents, as NUR reads them: packages, plus the special
# attributes `lib`, `modules` and `overlays`. It must not import <nixpkgs>
# itself (NUR evaluates it with its own); the default only makes
# `nix-build -A <package>` work from a checkout.
{
  pkgs ? import <nixpkgs> { },
}:

{
  # NixOS modules
  modules = import ./modules;

  jagex-launcher = pkgs.callPackage ./pkgs/jagex-launcher/package.nix { };
}
