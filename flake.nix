{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    {
      self,
      nixpkgs,
      devenv,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      lib = nixpkgs.lib;

      eachSystem = f: nixpkgs.lib.genAttrs systems (system: f system (nixpkgs.legacyPackages.${system}));
    in
    {
      devShells = eachSystem (
        system: pkgs: {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [ ./devenv.nix ];
          };
        }
      );
      packages = eachSystem (
        system: pkgs: {
          default = pkgs.buildGoModule {
            pname = "go-starter";
            version = "1.0.0";
            src = ./.;
            vendorHash = null;
          };
        }
      );

    };
}
