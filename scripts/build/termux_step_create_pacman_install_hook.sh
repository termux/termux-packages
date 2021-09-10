termux_step_create_pacman_install_hook() {
	# Unlike dpkg, pacman doesn't use separate scripts for package installation
	# hooks. Instead it uses a single script with functions.
	if [ -f "./preinst" ]; then
		echo "pre_install() {" >> .INSTALL
		cat preinst | grep -v '^#' >> .INSTALL
		echo "}" >> .INSTALL
		rm -f preinst
	fi
	if [ -f "./postinst" ]; then
		echo "post_install() {" >> .INSTALL
		cat postinst | grep -v '^#' >> .INSTALL
		echo "}" >> .INSTALL
		rm -f postinst
	fi
	if [ -f "./prerm" ]; then
		echo "pre_remove() {" >> .INSTALL
		cat prerm | grep -v '^#' >> .INSTALL
		echo "}" >> .INSTALL
		rm -f prerm
	fi
	if [ -f "./postrm" ]; then
		echo "post_remove() {" >> .INSTALL
		cat postrm | grep -v '^#' >> .INSTALL
		echo "}" >> .INSTALL
		rm -f postrm
	fi

	# Conversion from dpkg triggers to libalpm hooks is not supported
	# currently. Delete unneeded triggers file.
	rm -f triggers
}
