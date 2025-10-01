#!/usr/bin/env just --justfile

alias develop := shell
alias fmt := format
alias base := run

# run neovim
default: run

run:
    @nix run .

full:
    @nix run .#full

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

# compare package sizes between base and full profiles
size-compare:
    @echo "Building packages..."
    @nix build .#base -o result-base --quiet
    @nix build .#full -o result-full --quiet
    @echo ""
    @echo "Base profile:"
    @nix path-info -Sh ./result-base
    @echo ""
    @echo "Full profile:"
    @nix path-info -Sh ./result-full
    @echo ""
    @echo "Closure sizes (with dependencies):"
    @nix path-info -rSh ./result-base | tail -1
    @nix path-info -rSh ./result-full | tail -1
    @rm result-base result-full
