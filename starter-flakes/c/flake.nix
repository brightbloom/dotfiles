{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    mini-compile-commands = { url = "github:danielbarter/mini_compile_commands"; flake = false;};
  };

  outputs = { self, flake-utils, nixpkgs, mini-compile-commands }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          mcc-env = with pkgs; (callPackage mini-compile-commands {}).wrap stdenv;
          buildInputs = with pkgs; [
             cmake
             gnumake
             clang
             bear

          ];
        in
        with pkgs;
        {
          devShells.default = mkShell.override{stdenv = mcc-env;} {
            inherit buildInputs;
          };
        }
      );
}
