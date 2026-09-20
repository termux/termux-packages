TERMUX_PKG_HOMEPAGE=https://www.pgadmin.org
TERMUX_PKG_DESCRIPTION="Feature-rich web-based administration and development platform for PostgreSQL"
TERMUX_PKG_LICENSE="PostgreSQL"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="9.18"
TERMUX_PKG_SRCURL="git+https://github.com/pgadmin-org/pgadmin4"
TERMUX_PKG_GIT_BRANCH="REL-${TERMUX_PKG_VERSION/./_}"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag

TERMUX_PKG_DEPENDS="libpq, python, python-bcrypt, python-brotli, python-cryptography, python-greenlet, python-pillow, python-pip, python-psutil, python-pynacl"
# Needed for the Backup, Restore, Import/Export and PSQL tools.
TERMUX_PKG_RECOMMENDS="postgresql"
# bdist_wheel imports web/config.py, which pulls in pgadmin/__init__.py
# and its module tree, so all of that tree's imports must be importable
# by the host build python.
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel, flask, flask-socketio, flask-babel, flask-login, flask-mail, flask-paranoid, flask-security-too==5.8.*, flask-migrate, python-dateutil, cryptography, jsonformatter"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	termux_setup_nodejs
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR/web"
	export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
	corepack enable
	corepack prepare yarn@stable --activate
	yarn install --immutable
	yarn run bundle

	local _stage="$TERMUX_PKG_SRCDIR/pip-build/pgadmin4"
	mkdir -p "$_stage"
	cp -a "$TERMUX_PKG_SRCDIR"/web/. "$_stage/"
	rm -rf "$_stage/regression" "$_stage/node_modules" \
		"$_stage"/jest.config.js "$_stage"/babel.* "$_stage"/package.json \
		"$_stage"/.yarn* "$_stage"/yarn* "$_stage"/webpack.* \
		"$_stage"/.editorconfig "$_stage"/.eslint*
	cp "$TERMUX_PKG_SRCDIR/LICENSE" "$_stage/"

	cd "$TERMUX_PKG_SRCDIR/pip-build"
	python "$TERMUX_PKG_SRCDIR/pkg/pip/setup_pip.py" bdist_wheel
}

termux_step_make_install() {
	local _wheel
	_wheel=$(realpath "$TERMUX_PKG_SRCDIR"/pip-build/dist/pgadmin4-*.whl)
	pip install --no-deps --prefix="$TERMUX_PREFIX" "$_wheel"

	local _site_packages="$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION/site-packages"
	local _dist_info="$_site_packages/pgadmin4-$TERMUX_PKG_VERSION.dist-info"

	# The bundled HTML documentation is 119 MB of screenshots, which makes
	# the package ~107 MB compressed instead of ~8 MB. The "Online Help"
	# menu entry is served from it, everything else works without it.
	rm -rf "$_site_packages/pgadmin4/docs"
	sed -i '/^pgadmin4\/docs\//d' "$_dist_info/RECORD"

	# The pip dependencies of this package are installed on-device by the
	# postinst script generated from the wheel METADATA. There are no wheels
	# of psycopg-binary for Android, so depend on the pure Python psycopg,
	# which loads the libpq of Termux through ctypes.
	sed -i -E 's/^(Requires-Dist: psycopg)\[binary\]/\1/' "$_dist_info/METADATA"

	# config_distro.py is the upstream hook for packagers.
	cat >> "$_site_packages/pgadmin4/config_distro.py" <<-EOF

	# Termux
	UPGRADE_CHECK_ENABLED = False
	DEFAULT_BINARY_PATHS = {"pg": "$TERMUX_PREFIX/bin"}
	EOF

	# By default pgAdmin 4 runs in server mode, which needs a login account
	# and stores its data in /var/lib/pgadmin. Run it in desktop mode instead:
	# single user, no login, data in ~/.pgadmin.
	# Set PGADMIN_SERVER_MODE=ON to get the upstream behavior back.
	cat > "$TERMUX_PREFIX/bin/pgadmin4" <<-EOF
	#!$TERMUX_PREFIX/bin/sh
	export PGADMIN_SERVER_MODE="\${PGADMIN_SERVER_MODE:-OFF}"
	exec "$TERMUX_PREFIX/bin/python3" -m pgadmin4.pgAdmin4 "\$@"
	EOF
	chmod 700 "$TERMUX_PREFIX/bin/pgadmin4"
}
