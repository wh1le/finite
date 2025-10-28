.PHONY: build_image
build_image: ## Build image
	nix build .#nixosConfigurations.finite.config.system.build.sdImage

.PHONY: clean
clean:
	sudo nix-collect-garbage -d