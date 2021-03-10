{
  description = "KK's collection of flake templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages.hello = pkgs.hello;
        devShell = pkgs.mkShell {
          inputs = [ pkgs.hello ];
          nativeBuildInputs = with pkgs; [ cmake ];
        };
        defaultPackage = self.packages.${system}.hello;
      });
}
