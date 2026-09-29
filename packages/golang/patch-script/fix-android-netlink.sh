for f in src/net/interface_android.go src/syscall/netlink_android.go; do
	if [ -e "${f}" ]; then
		termux_error_exit "file ${f} already exists."
	fi
done

cp -T src/syscall/netlink_linux.go src/syscall/netlink_android.go
cp -T src/net/interface_linux.go src/net/interface_android.go

sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
	${TERMUX_SCRIPTDIR}/packages/golang/patch-script/fix-android-netlink.diff \
	| patch --silent -p1
