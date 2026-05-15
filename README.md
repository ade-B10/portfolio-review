# Base10 Portfolio Trajectory Review

Password-protected internal portfolio review site, hosted on GitHub Pages.

**Live URL** (after deploy): `https://ade-b10.github.io/portfolio-review/`

---

## How to access

1. Open the URL above
2. Enter the team password (saved in 1Password under "Base10 Portfolio Review")
3. The page remembers you for 14 days via local storage — only re-prompts after that

## What's in this repo

| File | Purpose |
|---|---|
| `index.html` | The encrypted page that GitHub Pages serves. **This is what users see.** Do not edit directly. |
| `.staticrypt.json` | Encryption salt — keeps the password hash stable across updates. **Do not commit changes to this file manually.** |
| `update.sh` | Re-encrypts a fresh source HTML and replaces `index.html`. Run this when the underlying content changes. |
| `source/` | (gitignored) Where the unencrypted source HTML lives locally before encryption. Never committed. |

## Updating the page

When the underlying portfolio review is refreshed (new company added, status change, etc.):

```bash
cd /Users/ade/Desktop/Urizen/portfolio-review-deploy

# 1. Drop the updated unencrypted HTML into source/
cp /Users/ade/Desktop/Urizen/Portfolio_Trajectory_Review.html source/

# 2. Re-encrypt
./update.sh

# 3. Commit and push
git add index.html
git commit -m "Refresh portfolio review (May 22, 2026)"
git push
```

GitHub Pages auto-deploys on push. The new version is live within ~30 seconds.

## Changing the password

Edit `update.sh` and change the `PASSWORD` variable. Run the script. Commit and push.

⚠️ Changing the password invalidates all existing 14-day "remember me" tokens — everyone on the team will need to re-enter the new one.

## Security notes

- Encryption: AES-256-CBC with PBKDF2-derived key (10,000 iterations)
- The encrypted blob is in the public repo, but the content is genuinely protected by the password
- Single shared password — if someone leaves the team, rotate the password
- Auditability: GitHub stores commit history but cannot see who accesses the live site (that's the tradeoff vs. Cloudflare Access)

## Migrating to Cloudflare Access later

When you want real per-user auth (Google SSO, individual access revocation, audit logs):

1. Move repo to private (requires GitHub Pro $4/mo)
2. Add the unencrypted HTML directly (delete encryption layer)
3. Deploy via Cloudflare Pages instead of GitHub Pages
4. Add a Cloudflare Access policy: "Only @base10.vc Google accounts"

About 30 minutes of work. Worth it if the site sticks around for a year+.

---

*Built with [StaticCrypt](https://github.com/robinmoisson/staticrypt). Maintained by Ade.*
