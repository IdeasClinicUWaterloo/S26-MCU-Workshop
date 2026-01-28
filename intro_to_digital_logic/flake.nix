{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };
 
  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };  
      in with pkgs; rec {

        symbolator = python3Packages.buildPythonApplication rec {
          pname = "symbolator";
          version = "1.0.2";

          # even if project only has setup.py, as this one does.
          # see https://nixos.org/manual/nixpkgs/stable/#buildpythonapplication-function
          pyproject = true;

          # Must manually specify this until hdlparse is in nixpkgs
          # (or pass in complicated build options)
          hdlparse = python3Packages.buildPythonApplication rec {
            pname = "hdlparse";
            version = "1.0.5";

            # even if project only has setup.py, as this one does.
            # see https://nixos.org/manual/nixpkgs/stable/#buildpythonapplication-function
            pyproject = true;

            src = fetchFromGitHub {
              owner = "leozqi";
              repo = "hdlparse";
              rev = "1.0.5";
              hash = "sha256-QyBZ7wrApX6KhyPGKaxut+x/++K+l6rvrJwUHmb29Dk=";
            };

            build-system = with python3Packages; [ setuptools ];
            dependencies = [];
          };
        src = fetchFromGitHub {
          owner = "leozqi";
          repo = "symbolator";
          rev = "1.0.2";
          hash = "sha256-2+kk60kEa1A3nnNT1HD2F9upmXx2SoMbOe+KUKX6s4s="; # always clear hash and rebuild to update hash when tag changes
        };

        build-system = with python3Packages; [ setuptools ];
        buildInputs = with pkgs; [ cairo gtk3 ];
        dependencies = with python3Packages; [ hdlparse pycairo pygobject3 ];
      };

  
        # Development environment
        devShell = pkgs.mkShell {
          packages = [
            python313
            python313Packages.jupyterlab
            python313Packages.yosys
            yosys
            netlistsvg
            symbolator
            cairo
            gtk3
          ];
        };
      }
    );
} 
