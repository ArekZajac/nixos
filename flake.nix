{
  description = "NixOS configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }:
    let
      mkHost = { hostname, system ? "x86_64-linux" }: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/common.nix
          ./hosts/${hostname}/configuration.nix
        ];
      };
    in
    {
      nixosConfigurations = {
        desktop = mkHost { hostname = "desktop"; };
        server = mkHost { hostname = "server"; };
      };
    };
}
