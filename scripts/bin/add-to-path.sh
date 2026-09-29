# Source this script in order to make the content of bin
# directory available in $PATH. Use only under Bash!

if [ -z "${BASH}" ]; then
	echo "Cannot source because your shell is not Bash!"
else
	TERMUX_BINPATH=$(realpath "$(dirname "${BASH_SOURCE}")")
	PATH="${TERMUX_BINPATH}:${PATH}"
	export PATH
	echo "Scripts from '$TERMUX_BINPATH' are now available in your \$PATH."
	unset TERMUX_BINPATH
fi
