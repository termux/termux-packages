termux_step_create_debscripts() {
	return 0
}

termux_step_create_debscripts__copy_from_dir() {

	local return_value

	local src_dir="${1:-}"
	local dest_dir="${2:-}"

	if [[ ! -d "$src_dir" ]]; then
		echo "Failed to find source directory '$src_dir' to copy debscripts from" 1>&2
		return 1
	fi

	return_value=0
	mkdir -p "$dest_dir" || return_value=$?
	if [ $return_value -ne 0 ]; then
		echo "Failed to create destination directory '$dest_dir' to copy debscripts to" 1>&2
		return 1
	fi

	(
		find "$src_dir" -mindepth 1 -maxdepth 1 -type f \
			-regextype posix-extended -regex "^.*/(postinst|postrm|preinst|prerm|config|conffiles|templates|triggers|clilibs|fortran_mod|runit|shlibs|starlibs|symbols)$" \
			-print0 | xargs -0 -n1 sh -c \
			'cp -a "$0" '"'${dest_dir//\'/\'\\\'\'}/'"

	)

}
