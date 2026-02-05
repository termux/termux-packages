TERMUX_SUBPKG_INCLUDE="
bin/mozc_emacs_helper
share/doc/mozc-ut/mozctoroku
share/emacs/site-lisp
"

TERMUX_SUBPKG_DEPENDS="emacs"
TERMUX_SUBPKG_DESCRIPTION="Mozc input method for emacs binding."

termux_step_create_subpkg_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	LC_ALL=C $TERMUX_PREFIX/bin/emacs -no-site-file -q -batch -f batch-byte-compile $TERMUX_PREFIX/share/emacs/site-lisp/mozc-emacs/*.el
	chmod 644 $TERMUX_PREFIX/share/emacs/site-lisp/mozc-emacs/*.elc
	EOF

	cat <<-EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	rm -f $TERMUX_PREFIX/share/emacs/site-lisp/mozc-emacs/*.elc
	EOF
}
