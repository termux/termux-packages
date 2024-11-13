#!/data/data/com.termux/files/usr/bin/env bash

main="@MAIN@"

mods="${TERMUX_PREFIX}/share/languagetool"
for jar in "${TERMUX_PREFIX}/share/java/langugetool"/*.jar; do
	mods=$mods:$jar
done

exec "${JAVA_HOME}/bin/java" -cp "$mods" "$main" "$@"
