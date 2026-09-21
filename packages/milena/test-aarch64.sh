#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

if [[ "$(uname -m)" != "aarch64" ]]; then
	echo "Milena Termux smoke test requires a physical aarch64 device." >&2
	exit 1
fi

DEB_PATH="${1:-}"
[[ -n "${DEB_PATH}" && -f "${DEB_PATH}" ]] || {
	echo "Usage: $0 /path/to/milena_*.deb" >&2
	exit 2
}

PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
command -v pkg >/dev/null || {
	echo "Termux pkg command is required." >&2
	exit 1
}

pkg install -y "${DEB_PATH}"
trap 'pkg remove -y milena >/dev/null 2>&1 || true' EXIT
pkg upgrade -y

MILENA="${PREFIX}/bin/milena"
test -x "${MILENA}"
set +e
output=$("${MILENA}" 2>&1)
status=$?
set -e
test "${status}" -eq 2
grep -q '^Milena ' <<<"${output}"

after_remove=0
pkg remove -y milena
[[ ! -e "${MILENA}" ]] || after_remove=1
if (( after_remove != 0 )); then
	echo "milena remained after pkg remove." >&2
	exit 1
fi
trap - EXIT
printf 'Milena Termux aarch64 install/upgrade/remove smoke test: PASS\n'
