{
  description = "Simple flake with flake-utils";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };

        hello = pkgs.hello;
        helloApp = flake-utils.lib.mkApp { drv = hello; };

      in {
        packages = { hello = hello; };
        defaultPackage = hello;

        apps = { hello = helloApp; };
        defaultApp = helloApp;

        devShell = pkgs.mkShell {
          inputsFrom = [ pkgs.hello ];
          buildInputs = [ ];
          nativeBuildInputs = [ ];
        };
      });
}
