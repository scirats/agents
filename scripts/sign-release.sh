#!/usr/bin/env bash
set -euo pipefail

# Usage: scripts/sign-release.sh <version>
# Requires an offline cosign private key. Defaults to ~/.config/autodod/cosign.key
VERSION="${1:?usage: $0 <version>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KEY="${COSIGN_KEY:-$HOME/.config/autodod/cosign.key}"
PASS="${COSIGN_PASSWORD_FILE:-$HOME/.config/autodod/cosign.password}"
OUT="$ROOT/dist"
mkdir -p "$OUT"

tar -C "$ROOT/developer" -czf "$OUT/developer-$VERSION.tar.gz" .
(cd "$OUT" && shasum -a 256 "developer-$VERSION.tar.gz" > SHA256SUMS)
COSIGN_PASSWORD="$(cat "$PASS")" cosign sign-blob \
  --key "$KEY" \
  --bundle "$OUT/SHA256SUMS.bundle" \
  --yes "$OUT/SHA256SUMS"

echo "Signed $OUT/developer-$VERSION.tar.gz"
echo "Update catalog.json sha256 with:"
cat "$OUT/SHA256SUMS"
