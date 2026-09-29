#!/usr/bin/env bash
# Builds The Yard for the Vault CDN: one folder per game, e.g. dist/wind/, dist/carbon/.
# Published by .github/workflows/publish.yml to builds.vaultlearninggames.org/fieldday/yardgames/<branch>/<game>/.
#
#   ./build.sh [out-dir]    (default: dist)
#
# carbon, nitrogen and water are the same repo (fielddaylab/cycle); only their src/scenes/config.js differs.
set -euo pipefail
cd "$(dirname "$0")"
OUT=${1:-dist}

git submodule update --init

rm -rf "$OUT"
mkdir -p "$OUT"

games=()
for dir in game/*/; do
  g=$(basename "$dir")
  games+=("$g")
  excludes=(--exclude .git --exclude .gitignore --exclude .gitmodules --exclude .DS_Store --exclude FloatingDropdown
            --exclude '[Mm]akefile' --exclude rsync-exclude --exclude README.md --exclude todo --exclude design.txt)
  [ -f "$dir/rsync-exclude" ] && excludes+=(--exclude-from "$dir/rsync-exclude")
  rsync -a "${excludes[@]}" "$dir" "$OUT/$g/"
done

cycle_config() {
  cat > "$OUT/$1/src/scenes/config.js" <<JS
var CARBON_GAME = 0;
var NITROGEN_GAME = 1;
var WATER_GAME = 2;
const game_type = $2;
JS
}
cycle_config carbon CARBON_GAME
cycle_config nitrogen NITROGEN_GAME
cycle_config water WATER_GAME

{
  echo '<!doctype html><html lang="en"><head><meta charset="utf-8"><title>The Yard</title></head><body>'
  echo '<h1>The Yard</h1><ul>'
  for g in "${games[@]}"; do echo "<li><a href=\"$g/\">$g</a></li>"; done
  echo '</ul></body></html>'
} > "$OUT/index.html"

echo "Built ${#games[@]} games into $OUT/: ${games[*]}"
