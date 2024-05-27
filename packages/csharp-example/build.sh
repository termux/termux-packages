TERMUX_PKG_HOMEPAGE=https://example.com
TERMUX_PKG_DESCRIPTION="CSharp Example"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_dotnet
}

termux_step_make() {
	dotnet new console -o hellocs #--aot
	pushd hellocs
	ls -l
	echo "$PWD/Program.cs"
	cat Program.cs
	echo "$PWD/hellocs.csproj"
	cat hellocs.csproj
	sed "/.*<\/Project>.*/d" -i hellocs.csproj
	cat <<-EOL >> hellocs.csproj
	<ItemGroup Condition="\$(RuntimeIdentifier.StartsWith('linux-bionic'))">
	<LinkerArg Include="-Wl,--undefined-version" />
	</ItemGroup>
	</Project>
	EOL
	dotnet publish hellocs.csproj -r ${DOTNET_TARGET_NAME} --self-contained -p:DisableUnsupportedError=true
	#-p:PublishAotUsingRuntimePack=true
	popd
}

termux_step_make_install() {
	pushd hellocs/bin/Release/net8.0/${DOTNET_TARGET_NAME}
	ls -l
	find publish -name "*.a" -exec chmod a-x "{}" \;
	find publish -name "*.dll" -exec chmod a-x "{}" \;
	find publish -name "*.so" -exec chmod a-x "{}" \;
	cp -r publish ${TERMUX_PREFIX}/lib/${TERMUX_PKG_NAME}
	ln -sv ../lib/${TERMUX_PKG_NAME}/hellocs ${TERMUX_PREFIX}/bin/hellocs
}
