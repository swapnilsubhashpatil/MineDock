#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/data"
OUTPUT_ZIP="$SCRIPT_DIR/data.zip"
TMP_ZIP="$SCRIPT_DIR/.data.tmp.zip"

if [[ ! -d "$DATA_DIR" ]]; then
  echo "Error: data directory not found at $DATA_DIR" >&2
  exit 1
fi

rm -f "$TMP_ZIP"

# Create a fresh archive from the repository root so the archive contains the data/ folder.
if command -v zip >/dev/null 2>&1; then
  (
    cd "$SCRIPT_DIR"
    zip -r -q "$TMP_ZIP" data
  )
elif command -v powershell.exe >/dev/null 2>&1; then
  PS_SCRIPT_DIR="$SCRIPT_DIR"
  if command -v cygpath >/dev/null 2>&1; then
    PS_SCRIPT_DIR="$(cygpath -w "$SCRIPT_DIR")"
  fi

  powershell.exe -NoProfile -Command "\
    \$ErrorActionPreference='Stop'; \
    Set-Location -LiteralPath '$PS_SCRIPT_DIR'; \
    if (Test-Path -LiteralPath '.data.tmp.zip') { Remove-Item -LiteralPath '.data.tmp.zip' -Force }; \
    Compress-Archive -Path 'data' -DestinationPath '.data.tmp.zip' -Force\
  "
elif command -v tar >/dev/null 2>&1; then
  (
    cd "$SCRIPT_DIR"
    tar -a -cf "$TMP_ZIP" data
  )
else
  echo "Error: no archive tool found. Install 'zip', or ensure 'powershell.exe' or 'tar' is available." >&2
  exit 1
fi

mv -f "$TMP_ZIP" "$OUTPUT_ZIP"
echo "Backup created: $OUTPUT_ZIP"
