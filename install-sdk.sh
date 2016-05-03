#!/bin/sh

# Read settings from .termuxrc if existing
test -f $HOME/.termuxrc && . $HOME/.termuxrc
: ${ANDROID_HOME:="${HOME}/lib/android-sdk"}

$ANDROID_HOME/tools/android update sdk --no-ui --all --no-https -t "build-tools-23.0.2"
$ANDROID_HOME/tools/android update sdk --no-ui --all --no-https -t "android-23"
