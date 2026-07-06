.PHONY: build_image lint clean

build_image:
	nix build .#nixosConfigurations.finite.config.system.build.sdImage

lint:
	nix run nixpkgs#nixfmt -- --check $(shell git ls-files '*.nix')
	nix run nixpkgs#statix -- check .
	nix run nixpkgs#deadnix -- --fail $(shell git ls-files '*.nix')

clean:
	sudo nix-collect-garbage -d