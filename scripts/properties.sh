TERMUX_ANDROID_BUILD_TOOLS_VERSION=28.0.3
TERMUX_NDK_VERSION=19

test -f "$HOME/.termuxrc" && . "$HOME/.termuxrc"

: "${ANDROID_HOME:="${HOME}/lib/android-sdk"}"
: "${NDK:="${HOME}/lib/android-ndk"}"
