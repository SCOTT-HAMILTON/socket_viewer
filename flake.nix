{
  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";  # IMPORTANT!!!
  };
  outputs = { self, nix-ros-overlay, nixpkgs }:
    nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ nix-ros-overlay.overlays.default ];
        };
      in {
        packages.default = pkgs.mkYarnPackage {
          name = "socket-viewer";
          src = pkgs.fetchFromGitHub {
            owner = "SCOTT-HAMILTON";
            repo = "socket_viewer";
            rev = "a17b59d76840fddbbef83943b70f664c18c965ce";
            fetchSubmodules = true;
            sha256 = "sha256-KBtFkifqA4xx+z16wKppJLrFeX83lEocK7dvf/5nvu0=";
          };
          packageJSON = ./package.json;
          yarnLock = ./yarn.lock;
          yarnNix = ./yarn.nix;
        };
        apps.default = nix-ros-overlay.inputs.flake-utils.lib.mkApp { drv = self.packages.${system}.default; };
      });
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
