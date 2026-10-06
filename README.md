# the-yard
Homepage for The Yard

## Retired: theyardgames.org redirects to Vault

Since 2026-10-05, theyardgames.org and wwwtest.theyardgames.org send every visitor to [Vault Learning Games](https://vaultlearninggames.org) with a permanent (301) redirect, set in `.htaccess`:

- Each game with a Vault page (`game/<name>.html`, `game/<name>/…`, and the old copies under `beta/game/`) goes to that page with the player open: `https://vaultlearninggames.org/<slug>#play`.
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
