{
  config,
  pkgs,
  lib,
  context,
  ...
}: let
  inherit (lib) boolToString mapAttrs mapAttrs';
  inherit (builtins) concatStringsSep;

  inputs = {
    # this is the nixpkgs flake input
    # TODO: add other inputs
    inherit (context) nixpkgs;
  };
  patchedInputs =
    if config.sys2x.overlays == []
    then inputs
    else inputs // {nixpkgs = patchPkgs inputs.nixpkgs;};

  # inject our overlays by patching the input flake to always include them in
  # the overlays array passed to the nixpkgs entrypoint
  patchPkgs = nixpkgs:
    pkgs.stdenv.mkDerivation rec {
      name = "source";
      src = nixpkgs;
      phases = "unpackPhase patchPhase installPhase";
      patchPhase = ''
        mkdir overlays
        ${concatStringsSep "\n" (map (path: "cp -Lrv '${path}' 'overlays/${baseNameOf path}'") config.sys2x.overlays.paths)}
        ${pkgs.buildPackages.alejandra}/bin/alejandra -q > default.nix <<EOF
          args @ {
            overlays ? [],
            config ? {},
            ...
          }:
          (
            $(cat ${src}/default.nix)
          )
          (args
            // {
              overlays =
                [
                  ${concatStringsSep "\n" (map (path: "(import ./overlays/${baseNameOf path})") config.sys2x.overlays.paths)}
                ]
                ++ overlays;
              config =
                config
                // {
                  allowUnfree = ${boolToString config.nixpkgs.config.allowUnfree or false};
                };
            })
        EOF
      '';
      installPhase = ''
        cp -r . $out
      '';
    };
in {
  # thanks tpw_rules and ElvishJerricco for these below!
  # publish inputs to new nix tools (nix shell, ...)
  nix.registry = mapAttrs (_: flake: {inherit flake;}) patchedInputs;
  # publish inputs to old nix tools (nix-shell, ...)
  # point the system nixpkgs to this flake by indirecting through
  # /etc so it changes when the system switches without having to
  # restart all the terminals.
  environment.etc =
    mapAttrs' (name: flake: {
      name = "nix/inputs/${name}";
      value.source = flake.outPath;
    })
    patchedInputs;
  nix.nixPath = ["/etc/nix/inputs"];
}
