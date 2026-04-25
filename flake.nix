{
  description = "NixOS configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, agenix, ... }:
    let
      mkHost = { hostname, system ? "x86_64-linux" }: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          agenix.nixosModules.default
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

      packages.x86_64-darwin.agenix = agenix.packages.x86_64-darwin.agenix;
      packages.x86_64-linux.agenix = agenix.packages.x86_64-linux.agenix;
    };
}
