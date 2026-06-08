#!/bin/sh
set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Please specify the archive"
    exit 1
fi

APK="$*"

if [ ! -f "$APK" ]; then
    echo "The specified file doesn't exist!"
    exit 1
fi

if ! [[ "$APK" =~ \.apk$ ]]; then
    echo "The file must be an .apk"
    exit 1
fi

NINECRAFT_DATA="$HOME/.local/share/ninecraft"
mkdir -p "$NINECRAFT_DATA"

ARCH=$(uname -m)

case "$ARCH" in
    x86_64|i686)
        LIB_PATH="lib/x86/libminecraftpe.so"
        ;;
    armv7*|armv8*|aarch64)
        LIB_PATH="lib/armeabi-v7a/libminecraftpe.so"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

if ! unzip -l "$APK" "$LIB_PATH" | grep -q "$(basename "$LIB_PATH")"; then
    echo "Failed to find $LIB_PATH inside APK! Wrong architecture?"
    exit 1
fi

unzip -qo "$APK" "assets/*" -d "$NINECRAFT_DATA"
unzip -qo "$APK" "res/*"    -d "$NINECRAFT_DATA"
unzip -qo "$APK" "lib/*"    -d "$NINECRAFT_DATA"

patchelf \
    --remove-needed libandroid.so \
    --remove-needed libc.so \
    --remove-needed libEGL.so \
    --remove-needed liblog.so \
    --remove-needed libm.so \
    --remove-needed libOpenSLES.so \
    --remove-needed libstdc++.so \
    --remove-needed libGLESv1_CM.so \
    --remove-needed libz.so \
    "$NINECRAFT_DATA/$LIB_PATH"