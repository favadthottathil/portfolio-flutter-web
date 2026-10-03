#!/usr/bin/env bash
# Vercel build entrypoint (see vercel.json). Vercel's build image has no
# Flutter, so we fetch the SDK at the exact version pinned in .fvmrc — the
# same file CI and local FVM read — so production never builds on a
# different toolchain than the one CI verified.
set -euo pipefail

cd "$(dirname "$0")"

FLUTTER_VERSION="$(sed -nE 's/.*"flutter"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' .fvmrc)"
if [[ -z "${FLUTTER_VERSION}" ]]; then
  echo "error: could not read the Flutter version from .fvmrc" >&2
  exit 1
fi

FLUTTER_DIR="${FLUTTER_DIR:-$PWD/flutter}"

# Reuse an SDK left behind by a previous build only if it is the right version.
if [[ -x "${FLUTTER_DIR}/bin/flutter" ]] &&
  [[ "$(git -C "${FLUTTER_DIR}" describe --tags --exact-match 2>/dev/null || true)" == "${FLUTTER_VERSION}" ]]; then
  echo "Using cached Flutter ${FLUTTER_VERSION}"
else
  echo "Fetching Flutter ${FLUTTER_VERSION}"
  rm -rf "${FLUTTER_DIR}"
  git clone --depth 1 --branch "${FLUTTER_VERSION}" \
    https://github.com/flutter/flutter.git "${FLUTTER_DIR}"
fi

export PATH="${FLUTTER_DIR}/bin:${PATH}"
export FLUTTER_SUPPRESS_ANALYTICS=true
flutter config --no-analytics >/dev/null
flutter --version

flutter pub get --enforce-lockfile
flutter build web --release

# Fail the deploy rather than ship a site whose resume button 404s.
test -f build/web/assets/assets/Favad_Thottathil_Resume.pdf ||
  { echo "error: resume PDF missing from build/web" >&2; exit 1; }
