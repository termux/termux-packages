for f in src/net/conf_android.go src/net/dnsclient_android.go; do
	if [ -e "${f}" ]; then
		termux_error_exit "Error: file ${f} already exists."
	fi
done

cp -T src/net/conf.go src/net/conf_android.go
cp -T src/net/dnsclient_unix.go src/net/dnsclient_android.go

sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
	${TERMUX_SCRIPTDIR}/packages/golang/fix-hardcoded-etc-resolv-conf.diff \
	| patch --silent -p1
