{
  description = "NixOS configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, agenix, home-manager, ... }:
    let
      mkHost = { hostname, system ? "x86_64-linux", extraModules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            agenix.nixosModules.default
            ./modules/common.nix
            ./hosts/${hostname}/configuration.nix
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        # Desktop: gaming workstation with niri + Home Manager.
        desktop = mkHost {
          hostname = "desktop";
          extraModules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.arek = import ./home/arek.nix;
            }
          ];
        };

        # Server: headless, no Home Manager / desktop modules.
        server = mkHost { hostname = "server"; };
      };

      packages.x86_64-darwin.agenix = agenix.packages.x86_64-darwin.agenix;
      packages.x86_64-linux.agenix = agenix.packages.x86_64-linux.agenix;
    };
}
