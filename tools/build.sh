#!/usr/bin/env bash
# Build Cart Life from this checkout with AGS (Windows, driven from WSL).
#
# Usage: tools/build.sh [--run]
#   --run   launch the fresh build (cartlife.exe) after compiling
#
# AGS can't build from a \\wsl$ path, so the project is mirrored to a
# Windows-local folder and compiled there. Override paths with:
#   CARTLIFE_MIRROR  Windows-side work folder (default C:\Users\<you>\cartlife_work)
#   AGS_EDITOR       path to AGSEditor.exe
#   SEVENZIP         path to 7z.exe
set -euo pipefail

ROOT=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
SRC="$ROOT/cartlife"
WINUSER=$(cd /mnt/c && cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r')
MIRROR="${CARTLIFE_MIRROR:-/mnt/c/Users/$WINUSER/cartlife_work}/cartlife"
AGS="${AGS_EDITOR:-/mnt/c/Program Files (x86)/Adventure Game Studio 3.6.2/AGSEditor.exe}"
SEVENZIP="${SEVENZIP:-/mnt/c/Program Files/7-Zip/7z.exe}"

# Sprites ship as a split .rar; extract once (acsprset.spr is gitignored).
if [ ! -f "$SRC/acsprset.spr" ] || [ "$(stat -c %s "$SRC/acsprset.spr")" -lt 1000000 ]; then
  echo "==> extracting sprites"
  (cd /mnt/c && "$SEVENZIP" e -y -o"$(wslpath -w "$SRC")" \
    "$(wslpath -w "$SRC/acpsprset_DECOMPRESSME.part1.rar")" acsprset.spr >/dev/null)
fi

echo "==> sync $SRC -> $MIRROR"
mkdir -p "$MIRROR"
rsync -a --delete \
  --exclude '/Compiled/Windows/' --exclude '/Compiled/Data/' \
  --exclude '/Compiled/Compiled.rar' --exclude '/_Debug/' \
  "$SRC/" "$MIRROR/"

echo "==> compile (headless)"
set +e
(cd /mnt/c && "$AGS" /compile "$(wslpath -w "$MIRROR/Game.agf")") 2>&1 | tr -d '\r' | grep -v '^$'
status=${PIPESTATUS[0]}
set -e

BUILD="$MIRROR/Compiled/Windows"
if [ "$status" -ne 0 ] || [ ! -f "$BUILD/cartlife.exe" ]; then
  echo "!! build failed (AGS exit $status)"; exit 1
fi
echo "==> build ready: $(wslpath -w "$BUILD")"

if [ "${1:-}" = "--run" ]; then
  echo "==> running cartlife.exe"
  cd "$BUILD" && ./cartlife.exe
fi
