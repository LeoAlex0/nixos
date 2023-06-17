{
  description = "System confirguration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { nixpkgs, nixos-hardware, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;
    in
    {
      homeManagerConfigurations = {
        leo = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            {
              home = {
                username = "leo";
                homeDirectory = "/home/leo";
              };
            }
          ];
        };
      };

      nixosConfigurations = {
        Leo-NSys = lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ];
        };
      };
    };
}
