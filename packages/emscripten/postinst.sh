#!@TERMUX_PREFIX@/bin/sh
DIR="@TERMUX_PREFIX@/opt/emscripten"
cd "${DIR}"
if [ -n "$(command -v npm)" ]; then
	if [ -n "$(npm --version | grep "^6.")" ]; then
		CMD="ci --production --no-optional"
	else
		CMD="install --omit=dev --omit=optional"
		rm -f package-lock.json
	fi
	echo "Running 'npm ${CMD}' in ${DIR} ..."
	npm ${CMD}
else
	echo '
WARNING: npm is not installed! Emscripten may not work properly without installing node modules!
' >&2
fi
echo '
===== Post-install notice =====

Please start a new session to use Emscripten.
You may want to clear the cache by running
the command below to fix issues.

emcc --clear-cache

===== Post-install notice =====
'
