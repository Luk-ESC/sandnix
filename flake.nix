{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      packages.x86_64-linux.default = pkgs.callPackage ./pkg.nix { };
    };
}
