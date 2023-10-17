{
  description = "System confirguration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # SecureBoot support
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { nixpkgs, nixos-hardware, lanzaboote, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        Leo-NSys = lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix
            nixos-hardware.nixosModules.microsoft-surface-pro-intel
            lanzaboote.nixosModules.lanzaboote # SecureBoot support
          ];
        };
      };
    };
}
