#!/usr/bin/env just --justfile

alias develop := shell
alias fmt := format

# run neovim
default: run

run:
    @nix run .

# invoke a Nix shell
shell:
    nix --experimental-features 'nix-command flakes' develop

# update flake inputs to latest revisions
update:
    @nix flake update

# format nix files in directory
format:
    nix fmt .

# run nix linters
lint:
    @statix check -i .direnv
    @deadnix .
