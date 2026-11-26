TERMUX_SUBPKG_DESCRIPTION=".NET 11.0 SDK"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="aspnetcore-runtime-11.0 (= ${TERMUX_PKG_FULLVERSION}), aspnetcore-targeting-pack-11.0 (= ${TERMUX_PKG_FULLVERSION}), dotnet-apphost-pack-11.0 (= ${TERMUX_PKG_FULLVERSION}), dotnet-runtime-11.0 (= ${TERMUX_PKG_FULLVERSION}), dotnet-targeting-pack-11.0 (= ${TERMUX_PKG_FULLVERSION}), dotnet-templates-11.0 (= ${TERMUX_PKG_FULLVERSION})"
TERMUX_SUBPKG_INCLUDE=$(cat "${TERMUX_PKG_TMPDIR}"/dotnet-sdk.txt)

termux_step_create_subpkg_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	cat <<- EOL

	====================
	NET SDK known issues
	====================

	'export MSBuildDebugEngine=1'
	variable to capture more build logs.

	Pass '-v n' or '-v d' or '-v diag' to increase
	log verbosity.

	Runs on CoreCLR (Mono on i686). NativeAOT
	publishing is not available on the device.
	Check logcat for runtime errors.

	EOL
	EOF
}
