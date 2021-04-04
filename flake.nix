{
  description = "KK's collection of flake templates";

  outputs = { self }: {
    templates = {
      trivial = {
        path = ./trivial;
        description = "A very basic flake";
      };
      haskell-nix = {
        path = ./haskell-nix;
        description = "Flake to build Haskell project using haskell.nix";
      };
    };
    defaultTemplate = self.templates.trivial;
  };
}
