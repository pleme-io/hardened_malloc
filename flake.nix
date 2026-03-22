{
  description = "hardened_malloc — GrapheneOS hardened memory allocator (pleme-io fork)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, devenv }:
  let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.stdenv.mkDerivation {
        pname = "hardened-malloc";
        version = "2025.03";
        src = ./.;

        makeFlags = [
          "VARIANT=default"
          "PREFIX=$(out)"
        ];

        installPhase = ''
          mkdir -p $out/lib
          cp out/libhardened_malloc.so $out/lib/ 2>/dev/null || true
          cp out/libhardened_malloc.a $out/lib/ 2>/dev/null || true
          mkdir -p $out/include
          cp -r include/* $out/include/
        '';

        meta = with pkgs.lib; {
          description = "GrapheneOS hardened memory allocator";
          homepage = "https://github.com/GrapheneOS/hardened_malloc";
          license = licenses.mit;
          platforms = platforms.linux;
        };
      };

      light = pkgs.stdenv.mkDerivation {
        pname = "hardened-malloc-light";
        version = "2025.03";
        src = ./.;

        makeFlags = [
          "VARIANT=light"
          "PREFIX=$(out)"
        ];

        installPhase = ''
          mkdir -p $out/lib
          cp out-light/libhardened_malloc-light.so $out/lib/ 2>/dev/null || true
          cp out-light/libhardened_malloc-light.a $out/lib/ 2>/dev/null || true
          mkdir -p $out/include
          cp -r include/* $out/include/
        '';

        meta = with pkgs.lib; {
          description = "GrapheneOS hardened memory allocator (light variant)";
          homepage = "https://github.com/GrapheneOS/hardened_malloc";
          license = licenses.mit;
          platforms = platforms.linux;
        };
      };
    });

    overlays.default = final: prev: {
      hardened-malloc = self.packages.${final.system}.default;
      hardened-malloc-light = self.packages.${final.system}.light;
    };

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = devenv.lib.mkShell {
        inputs = { inherit nixpkgs devenv; };
        inherit pkgs;
        modules = [{
          packages = with pkgs; [ gnumake gcc gdb valgrind ];
          env.CC = "gcc";
        }];
      };
    });
  };
}
