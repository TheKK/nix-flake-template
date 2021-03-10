{
  description = "KK's collection of flake templates";

  outputs = { self }: {
    templates = {
      trivial = {
        path = ./trivial;
        description = "A very basic flake";
      };
    };
    defaultTemplate = self.templates.trivial;
  };
}
