#!/bin/sh
set -euo pipefail

NINECRAFT_BIN="$(dirname "$(readlink -f "$0")")"
NINECRAFT_DATA="$HOME/.local/share/ninecraft"

mkdir -p "$NINECRAFT_DATA"
cd "$NINECRAFT_DATA" || { zenity --error --text="Failed to change directory to $NINECRAFT_DATA"; exit 1; }

ARCH=$(uname -m)

case "$ARCH" in
    x86_64|i686)
        LIB_PATH="lib/x86/libminecraftpe.so"
        ;;
    armv7*|armv8*|aarch64)
        LIB_PATH="lib/armeabi-v7a/libminecraftpe.so"
        ;;
    *)
        zenity --error --text="Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

if [ ! -f "$LIB_PATH" ]; then
    zenity --error --text="Failed to find $LIB_PATH!\nRun ninecraft-extract /path/to/pe.apk\n\nEnsure the APK matches your system's architecture (x86 / arm)"
    exit 1
fi

exec $NINECRAFT_BIN/ninecraft "$@"