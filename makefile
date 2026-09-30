# Builds The Yard for the Vault CDN: one folder per game in dist/, e.g. dist/wind/, dist/carbon/.
# CI (.github/workflows/publish.yml) runs `make build` and publishes dist/ to
# builds.vaultlearninggames.org/fieldday/yardgames/<branch>/<game>/.
#
# carbon, nitrogen and water are the same repo (fielddaylab/cycle); only their src/scenes/config.js differs.

SHELL := /bin/bash
OUT   := dist
# Every game is a submodule under game/.
GAMES := $(sort $(notdir $(shell git config -f .gitmodules --get-regexp '^submodule\..*\.path$$' | cut -d' ' -f2)))

# Repo files that aren't part of a game.
EXCLUDES := --exclude .git --exclude .gitignore --exclude .gitmodules --exclude .DS_Store --exclude FloatingDropdown \
	--exclude '[Mm]akefile' --exclude rsync-exclude --exclude README.md --exclude todo --exclude design.txt

.PHONY: build clean submodules pullnewestgamesubmodules

build: submodules
	rm -rf $(OUT) && mkdir -p $(OUT)
	@for g in $(GAMES); do \
	  x=; [ -f game/$$g/rsync-exclude ] && x="--exclude-from game/$$g/rsync-exclude"; \
	  rsync -a $(EXCLUDES) $$x game/$$g/ $(OUT)/$$g/ || exit 1; \
	done
	$(call cycle_config,carbon,CARBON_GAME)
	$(call cycle_config,nitrogen,NITROGEN_GAME)
	$(call cycle_config,water,WATER_GAME)
	@{ echo '<!doctype html><html lang="en"><head><meta charset="utf-8"><title>The Yard</title></head><body>'; \
	  echo '<h1>The Yard</h1><ul>'; \
	  for g in $(GAMES); do echo "<li><a href=\"$$g/\">$$g</a></li>"; done; \
	  echo '</ul></body></html>'; } > $(OUT)/index.html
	@echo "Built $(words $(GAMES)) games into $(OUT)/: $(GAMES)"

define cycle_config
@printf 'var CARBON_GAME = 0;\nvar NITROGEN_GAME = 1;\nvar WATER_GAME = 2;\nconst game_type = %s;\n' $(2) > $(OUT)/$(1)/src/scenes/config.js
endef

clean:
	rm -rf $(OUT)

# Submodule management

submodules:
	@git submodule init && git submodule update

pullnewestgamesubmodules:
	@git submodule update --remote --merge
