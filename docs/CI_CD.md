# CI/CD

Everything runs from [`.github/workflows/ci-cd.yml`](../.github/workflows/ci-cd.yml).
The Flutter version is pinned once, in [`.fvmrc`](../.fvmrc), and read by CI,
by [`build.sh`](../build.sh) on Vercel, and by [FVM](https://fvm.app) locally.
CI and production can't end up on different toolchains.

## Pipeline

```
quality ─┐
         ├─> smoke ─┬─> deploy-preview     (pull requests, same-repo branches)
build ───┘          └─> deploy-production  (push to main)
```

| Job | What it enforces |
|---|---|
| **quality** | `pub get --enforce-lockfile` (the committed lockfile is authoritative), `dart format --set-exit-if-changed`, `flutter analyze --fatal-infos --fatal-warnings`, and `flutter test --coverage` (coverage uploaded as an artifact). |
| **build** | `flutter build web --release`, then checks that `index.html`, `main.dart.js`, `flutter_bootstrap.js` and the resume PDF are present. Fails if `main.dart.js` goes over the 2.5 MiB budget (`MAIN_JS_BUDGET_BYTES`) and writes a size table to the run summary. Uploads `build/web` as the `web-build` artifact. |
| **smoke** | Serves the artifact and loads it in headless Chromium at desktop and phone sizes via [`tool/smoke`](../tool/smoke). It fails if `<flutter-view>` never mounts, if any console or page error is logged, or if the resume URL doesn't return a PDF. Screenshots are uploaded as the `smoke-screenshots` artifact. |
| **deploy-preview** | Deploys the **same artifact** that was tested (`vercel deploy --prebuilt`). The preview URL appears on the PR as a GitHub deployment. |
| **deploy-production** | Same, with `--prod`, behind the `production` environment. Afterwards it checks `/`, the resume PDF and a deep link (SPA fallback) on the live site. |

Other automation:

- **[Link check](../.github/workflows/link-check.yml)**: [lychee](https://lychee.cli.rs) checks every URL in `lib/` weekly, and on PRs that touch content files. It isn't part of the main pipeline, so a third-party outage never blocks a merge. Add false positives to [`.lycheeignore`](../.lycheeignore).
- **[Dependabot](../.github/dependabot.yml)**: weekly pub and GitHub Actions updates and monthly smoke-tool updates, grouped so you get a few PRs rather than many.
- **Supply-chain hygiene**: every third-party action is pinned to a full commit SHA (Dependabot keeps the pins current), workflows default to `contents: read`, and checkout doesn't persist credentials.
- **Concurrency**: a new push cancels the stale run for the same PR. Runs on `main` are never cancelled mid-deploy.

## Turning on GitHub-driven deploys

Until this is set up, the deploy jobs are skipped and Vercel's Git integration
keeps deploying as before, now using the pinned version via `build.sh`.

1. In Vercel, create a token: **Account Settings → Tokens**.
2. Find the IDs. Run `npx vercel link` locally, then read `.vercel/project.json`
   (`orgId`, `projectId`). Or find them under **Project → Settings → General**.
3. In GitHub, go to **Settings → Secrets and variables → Actions** and add:
   - Secret `VERCEL_TOKEN`
   - Variables `VERCEL_ORG_ID` and `VERCEL_PROJECT_ID`
   - Optional variable `PRODUCTION_URL` (e.g. `https://portfolio-favad-ts-projects.vercel.app`) for the post-deploy check
4. Stop Vercel from also building every push, otherwise each commit deploys
   twice. Add this to [`vercel.json`](../vercel.json):
   ```json
   "git": { "deploymentEnabled": false }
   ```
5. Recommended: under **Settings → Environments → production**, restrict
   deployments to `main` and add yourself as a required reviewer if you want a
   manual approval gate.
6. Recommended: add a branch protection rule (or ruleset) on `main` that
   requires the **Format · Analyze · Test**, **Build web (release)** and
   **Smoke test (headless Chromium)** checks to pass.

## Running the checks locally

```bash
flutter pub get --enforce-lockfile
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos --fatal-warnings
flutter test

flutter build web --release
python3 -m http.server 8080 --directory build/web &
(cd tool/smoke && npm ci && npx playwright install chromium && npm run smoke)
```

## Upgrading Flutter

Change the version in `.fvmrc` and nothing else. CI, Vercel and FVM all pick
it up, and the PR shows whether the new SDK passes analysis, tests and the
bundle budget before it reaches production.
