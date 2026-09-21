#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${1:-}"
[[ -n "${SOURCE_DIR}" && -d "${SOURCE_DIR}" ]] || {
	echo "Usage: $0 SOURCE_DIR [MILENA_BINARY SCRIPT]" >&2
	exit 2
}

now_ns() {
	local value
	value=$(date +%s%N)
	[[ "${value}" != *N* ]] || {
		echo "date with nanosecond support is required" >&2
		exit 1
	}
	printf '%s\n' "${value}"
}

runs="${MILENA_BENCHMARK_RUNS:-3}"
[[ "${runs}" =~ ^[1-9][0-9]*$ ]] || {
	echo "MILENA_BENCHMARK_RUNS must be a positive integer" >&2
	exit 2
}

for run in $(seq 1 "${runs}"); do
	make -C "${SOURCE_DIR}" clean >/dev/null
	start=$(now_ns)
	make -C "${SOURCE_DIR}" -j "${TERMUX_PKG_MAKE_PROCESSES:-1}" \
		CC="${CC:-cc}" \
		CFLAGS="${CFLAGS:-} -std=c17 -Iinclude" \
		LDFLAGS="${LDFLAGS:-} -lm" milena >/dev/null
	end=$(now_ns)
	printf 'compile_run=%s compile_ns=%s\n' "${run}" "$((end - start))"
done

if (( $# == 3 )); then
	binary="$2"
	script="$3"
	[[ -x "${binary}" && -f "${script}" ]] || {
		echo "MILENA_BINARY must be executable and SCRIPT must exist" >&2
		exit 2
	}
	for run in $(seq 1 "${runs}"); do
		start=$(now_ns)
		"${binary}" run "${script}" >/dev/null
		end=$(now_ns)
		printf 'execution_run=%s execution_ns=%s\n' "${run}" "$((end - start))"
	done
fi
