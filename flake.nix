{
  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-22.05"; 
    # nixpkgs.url = "nixpkgs/nixos-unstable"; 
    # nixpkgs.url = "nixpkgs/master"; 
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };
  outputs =
    { self, nixpkgs, flake-utils, flake-compat }:
    flake-utils.lib.eachSystem [
      "x86_64-linux"
    ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.cudaSupport = true;
          };
        in
        rec {
          devShells.default =
            pkgs.mkShell
              {
                LD_LIBRARY_PATH = "/usr/lib/wsl/lib";
                packages = [
                  pkgs.rnix-lsp
                  (pkgs.python3.withPackages (p: with p; [
                    pytorch
                    numpy
                    tokenizers
                  ]))
                  pkgs.cudatoolkit
                ];
              };
        }
      );
}
