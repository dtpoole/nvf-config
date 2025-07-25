{pkgs}: {
  default = pkgs.mkShellNoCC {
    nativeBuildInputs = with pkgs; [
      alejandra
      deadnix
      just
      statix
    ];

    shellHook = ''
      ${pkgs.figurine}/bin/figurine -f 'JS Block Letters.flf' nvf - neovim
      echo && just --list && echo
      PS1='[nix] \W \$ '
    '';
  };
}
