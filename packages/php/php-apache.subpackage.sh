TERMUX_SUBPKG_DESCRIPTION="Apache 2.0 Handler module for PHP"
TERMUX_SUBPKG_DEPENDS="apache2, apr-util"
TERMUX_SUBPKG_INCLUDE="libexec/apache2/libphp.so"

termux_step_create_subpkg_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo
	echo "    Extensions for PHP/Apache are packaged under the name of 'php-apache-*'"
	echo "    and are installed under the directory '\\\$PREFIX/lib/php-apache/'."
	echo
	echo "    (Extensions under '\\\$PREFIX/lib/php/' will not work with PHP/Apache.)"
	echo
	EOF
}
