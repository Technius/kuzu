{
  description = "Nix flake for kuzu";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = final: self: {
          kuzuPkgs = final.callPackages ./scripts/nix/kuzuPkgs.nix { };

          inherit (final.kuzuPkgs) kuzu kuzu-nodejs;
        };
        pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
      in
      {

        packages.kuzu = pkgs.kuzu;
        packages.kuzu-nodejs = pkgs.kuzu-nodejs;

        packages.default = self.packages.${system}.kuzu;

        devShells.default = pkgs.kuzu;
        devShells.kuzu-nodejs = pkgs.mkShell {
          inputsFrom = [ pkgs.kuzu-nodejs ];
        };

        formatter = pkgs.nixpkgs-fmt;

        inherit overlay;
      });
}
