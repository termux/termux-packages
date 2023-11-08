#!/usr/bin/env bash

qmake_output=$(@TERMUX_PREFIX@/opt/qt/cross/bin/qmake $@)

echo "${qmake_output}" | \
sed \
	-e "s|^QT_INSTALL_BINS:.*|QT_INSTALL_BINS:@TERMUX_PREFIX@/opt/qt/cross/bin|"
