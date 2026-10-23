.PHONY: build_image lint clean deploy_test_pi deploy_to_pi

build_image:
	nix build .#nixosConfigurations.finite.config.system.build.sdImage

lint:
	nix run nixpkgs#nixfmt -- --check $(shell git ls-files '*.nix')
	nix run nixpkgs#statix -- check .
	nix run nixpkgs#deadnix -- --fail $(shell git ls-files '*.nix')

build_image:
	nix build .#nixosConfigurations.finite.config.system.build.sdImage

clean:
	sudo nix-collect-garbage -d

deploy_test_pi:
	NIX_SSHOPTS="-p 1234" nixos-rebuild test \
		--flake path:.#finite \
		--target-host "$(or $(PI_USER),$(error PI_USER is required))@$(or $(PI_HOST),$(error PI_HOST is required))" \
		--sudo --ask-sudo-password

deploy_to_pi:
	NIX_SSHOPTS="-p 1234" nixos-rebuild switch \
		--flake path:.#finite \
		--target-host "$(or $(PI_USER),$(error PI_USER is required))@$(or $(PI_HOST),$(error PI_HOST is required))" \
		--sudo --ask-sudo-password
