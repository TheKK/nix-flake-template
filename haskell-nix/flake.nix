{
  description = "Flake to build Haskell project using haskell.nix";

  inputs = {
    haskell-nix.url = "github:input-output-hk/haskell.nix";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.follows = "haskell-nix/nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, haskell-nix, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        overlays = [
          haskell-nix.overlay
          (final: prev: {
            # Make ./. a cabal directory!
            yourProject = final.haskell-nix.cabalProject' {
              src = pkgs.haskell-nix.haskellLib.cleanGit {
                name = "yourProject";
                src = ./.;
              };
              compiler-nix-name = "ghc884";
            };
          })
        ];

        pkgs = import nixpkgs { inherit system overlays; };
        hsPkgs = pkgs.haskellPackages;

        yourProject = pkgs.yourProject;
        yourProject-flake = yourProject.flake { };

        tools = {
          cabal = "latest";
          haskell-language-server = "latest";
        };
        tools-gc-roots = let
          toolsDrv = builtins.attrValues (yourProject.tools tools);
          toolsProjectPlanNix = builtins.map (t: t.project.plan-nix) toolsDrv;
        in toolsDrv ++ toolsProjectPlanNix;

        gc-roots = [ yourProject.plan-nix yourProject.roots ] ++ tools-gc-roots;

      in yourProject-flake // {
        inherit yourProject-flake;
        defaultPackage =
          yourProject-flake.packages."yourProject:exe:yourExecutable";
        defaultApp = yourProject-flake.apps."yourProject:exe:yourExecutable";
        devShell = yourProject.shellFor {
          inherit tools;
          nativeBuildInputs = [ hsPkgs.hpack ] ++ gc-roots;
          withHoogle = false;
          exactDeps = true;
        };
      });
}
