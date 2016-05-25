#!/bin/sh

# Install desired parts of the Android SDK:
test -f $HOME/.termuxrc && . $HOME/.termuxrc
: ${ANDROID_HOME:="${HOME}/lib/android-sdk"}
echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --no-https -t "build-tools-23.0.3"
echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --no-https -t "android-23"
