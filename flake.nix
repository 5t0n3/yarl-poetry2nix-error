{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/e92039b55bcd58469325ded85d4f58dd5a4eaf58"; # latest nixos-unstable as of testing
  inputs.poetry2nix.url = "github:nix-community/poetry2nix/7acb78166a659d6afe9b043bb6fe5cb5e86bb75e";

  outputs = {
    self,
    nixpkgs,
    poetry2nix,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      overlays = [poetry2nix.overlays.default];
      inherit system;
    };
  in {
    packages.${system}.just-yarl = pkgs.poetry2nix.mkPoetryApplication {
      projectDir = ./.;

      # only an issue for python < 3.11
      # see https://github.com/aio-libs/yarl/blob/6e61b44a05e590be14ab776904b83f544daf8c49/pyproject.toml#L8
      python = pkgs.python310;

      overrides = pkgs.poetry2nix.overrides.withDefaults (
        final: prev: {
          # the build breaks if this is commented out
          # yarl = prev.yarl.overridePythonAttrs (old: {
          #   buildInputs = old.buildInputs ++ [pkgs.python310Packages.tomli];
          # });
        }
      );
    };
  };
}
