{
  description = "Custom Syzkaller Build for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system}.default = pkgs.buildGoModule rec {
      pname = "syzkaller";
      version = "latest";

      src = pkgs.fetchFromGitHub {
        owner = "google";
        repo = "syzkaller";
        rev = "9c2d0995bb06e7518555bd3b755e327c89b59823";
        hash = "sha256-BfEfq742xlU5Ak3+fsGIKipp2UvvKbzaFiORHZvFvFA";
      };

      vendorHash = "sha256-ORO4uu45tCb2bGybdIP/avNVj1j3/V8GXSeWdVYdhyg=";
      
      allowGoReference = true;

      nativeBuildInputs = with pkgs; [
        git
        pkg-config
        ncurses
        bash
        pkgsCross.mingwW64.buildPackages.gcc
      ];

      buildInputs = [
        pkgs.glibc.static
      ];

      postPatch = ''
        git init
        git config user.email "nix@localhost"
        git config user.name "nix"
        git add .
        git commit --allow-empty -m "placeholder commit so nix creates the .git required for syzkaller"

        sed -i '/GOFLAGS/d' Makefile
        sed -i 's/prog.GitRevision == ""/false/g' syz-manager/manager.go || true
        sed -i 's/prog.GitRevision == ""/false/g' syz-fuzzer/fuzzer.go || true
      '';

      buildPhase = ''
        export TARGETOS=windows
        export TARGETARCH=amd64
        
        unset GOFLAGS
        export GOFLAGS="-mod=vendor"
        
        export NO_BUILD_SYZ_ENV=1
        export CGO_ENABLED=0
        
        make manager
        make target
      '';

      installPhase = ''
        mkdir -p $out
        cp -a bin $out/
      '';
    };

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        go
        gcc
        qemu_kvm
        self.packages.${system}.default
      ];
    };
  };
}
