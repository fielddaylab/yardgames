# the-yard
Homepage for The Yard

## Retired: theyardgames.org redirects to Vault

Since 2026-10-05, theyardgames.org and wwwtest.theyardgames.org send every visitor to [Vault Learning Games](https://vaultlearninggames.org) with a permanent (301) redirect, set in `.htaccess`:

- Any path that names one of the 10 games as a whole path segment goes to that game's Vault page with the player open (`https://vaultlearninggames.org/<slug>#play`). That covers `game/<name>.html`, `game/<name>/iframe.html`, the old copies under `beta/game/`, copies at other paths (`nitrogen/iframe.html`, `fieldday/yardgames/<name>/…`), and mangled links like `game/water.html&x=y`. The paths come from the site's Google Analytics landing pages, 2026-10-05.
- Everything else goes to the Vault home page. That includes `game/model.html`, which has no Vault page.
- `/.well-known/` is not redirected, so Plesk can keep renewing the HTTPS certificate.

The games themselves are still built from this repository and published to Vault's CDN by `.github/workflows/publish.yml` (`make build`).

## Deploying

DoIT's Plesk deploys the sites straight from this repository (Plesk → Websites & Domains → the domain → Git).

| Branch | Site |
|---|---|
| `production` | https://theyardgames.org |
| `wwwtest` | https://wwwtest.theyardgames.org |

- Pushing to one of those branches runs `.github/workflows/plesk-deploy.yml`. It joins the campus VPN, SSHes into porky with the fielddaylab.wisc.edu deploy key, and from there calls that site's Plesk webhook (repository secrets `PLESK_WEBHOOK_PRODUCTION`/`PLESK_WEBHOOK_WWWTEST`), and Plesk pulls the branch into the site's `/httpdocs`. The webhooks (port 8443 on porky and petunia) only answer inside the campus network, not from GitHub's webhooks and not over the VPN. If a deploy doesn't show up, re-run that workflow or use **Pull now** on the domain's Git page.
- Plesk doesn't check out the `game/` submodules. The game folders already on the servers stay as they are, and the redirects cover them.
- Keep `.htaccess` the same on both branches.
