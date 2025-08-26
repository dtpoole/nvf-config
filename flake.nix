{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };
  outputs = {
    nixpkgs,
    nvf,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    forEachSystem = nixpkgs.lib.genAttrs systems;

    pkgsFor = forEachSystem (
      system:
        import nixpkgs {
          inherit system;
        }
    );
  in {
    devShells = forEachSystem (system: import ./shell.nix {pkgs = pkgsFor.${system};});
    formatter = forEachSystem (system: pkgsFor.${system}.alejandra);
    packages = forEachSystem (system: {
      default =
        (nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [./nvf-config.nix];
        }).neovim;
    });

    nixosModules = {
      default = import ./module.nix;
      nvf-config = import ./module.nix;
    };

    homeManagerModules = {
      default = import ./module.nix;
      nvf-config = import ./module.nix;
    };
  };
}
