#Submodule management

submodules:
	@git submodule init && git submodule update

pullnewestgamesubmodules:
	@git submodule update --remote --merge

#Cycle Config

cycleconfig: game/carbon/src/scenes/config.js game/nitrogen/src/scenes/config.js game/water/src/scenes/config.js
	

game/nitrogen:
	@git submodule init && git submodule update

game/water:
	@git submodule init && git submodule update

game/carbon:
	@git submodule init && git submodule update

game/nitrogen/src/scenes/config.js: game/nitrogen
	@cp game/nitrogen/src/scenes/config.js{.template,} && echo 'game_type = NITROGEN_GAME;' >> game/nitrogen/src/scenes/config.js

game/water/src/scenes/config.js: game/water
	@cp game/water/src/scenes/config.js{.template,} && echo 'game_type = WATER_GAME;' >> game/water/src/scenes/config.js

game/carbon/src/scenes/config.js: game/carbon
	@cp game/carbon/src/scenes/config.js{.template,} && echo 'game_type = CARBON_GAME;' >> game/carbon/src/scenes/config.js

cleancycleconfig:
	@rm game/nitrogen/src/scenes/config.js ; rm game/water/src/scenes/config.js ; rm game/carbon/src/scenes/config.js

#Deployment

# Vault CDN build: one folder per game in dist/ (CI publishes it; see .github/workflows/publish.yml)
dist:
	@./build.sh dist

.PHONY: dist


deploy: cycleconfig
	rsync -vrc * tyg@theyardgames.org:/httpdocs --exclude-from rsync-exclude

deploy-beta: cycleconfig
	rsync -vrc * tyg@theyardgames.org:/httpdocs/beta --exclude-from rsync-exclude
