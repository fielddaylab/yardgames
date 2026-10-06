# the-yard
Homepage for The Yard

## Retired: theyardgames.org redirects to Vault

Since 2026-10-05, theyardgames.org and wwwtest.theyardgames.org send every visitor to [Vault Learning Games](https://vaultlearninggames.org) with a permanent (301) redirect, set in `.htaccess`:

- Any path that names one of the 10 games as a whole path segment goes to that game's Vault page with the player open (`https://vaultlearninggames.org/<slug>#play`). That covers `game/<name>.html`, `game/<name>/iframe.html`, the old copies under `beta/game/`, copies at other paths (`nitrogen/iframe.html`, `fieldday/yardgames/<name>/…`), and mangled links like `game/water.html&x=y`. The paths come from the site's Google Analytics landing pages, 2026-10-05.
- Everything else goes to the Vault home page. That includes `game/model.html`, which has no Vault page.
- `/.well-known/` is not redirected, so Plesk can keep renewing the HTTPS certificate.

The games themselves are still built from this repository and published to Vault's CDN by `.github/workflows/publish.yml` (`make build`).

## Deploying

DoIT's Plesk deploys the sites straight from this repository (Plesk → Websites & Domains → the domain → Git). Nothing deploys from GitHub Actions.

| Branch | Site |
|---|---|
| `production` | https://theyardgames.org |
| `wwwtest` | https://wwwtest.theyardgames.org |

- Plesk pulls a pushed branch and copies it into the site's `/httpdocs`, dotfiles included, so `.htaccess` deploys with it. If a push doesn't show up, use **Pull now** on the domain's Git page. Automatic pulls need the webhook URL from that page added to this repository's GitHub webhooks.
- Plesk doesn't check out the `game/` submodules. The game folders already on the servers stay as they are, and the redirects cover them.
- Keep `.htaccess` the same on both branches.
