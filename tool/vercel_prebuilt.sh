#!/usr/bin/env bash
# Wraps build/web in Vercel's Build Output API v3 layout so CI can deploy the
# exact artifact it tested with `vercel deploy --prebuilt`, instead of letting
# Vercel rebuild from source. Mirrors the SPA rewrite in vercel.json.
set -euo pipefail

cd "$(dirname "$0")/.."
test -f build/web/index.html || { echo "error: build/web is missing; build first" >&2; exit 1; }

out=.vercel/output
rm -rf "$out"
mkdir -p "$out"
cp -R build/web "$out/static"
cat > "$out/config.json" <<'JSON'
{
  "version": 3,
  "routes": [
    { "handle": "filesystem" },
    { "src": "/(.*)", "dest": "/index.html" }
  ]
}
JSON
echo "Prepared $out ($(du -sh "$out/static" | cut -f1))"
