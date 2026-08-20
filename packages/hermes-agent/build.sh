TERMUX_PKG_HOMEPAGE=https://github.com/NousResearch/hermes-agent
TERMUX_PKG_DESCRIPTION="Self-improving AI agent that creates and improves skills from experience"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="adybag14-cyber <252811164+adybag14-cyber@users.noreply.github.com>"
TERMUX_PKG_VERSION="2026.8.16"
TERMUX_PKG_SRCURL="https://github.com/NousResearch/hermes-agent/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=655639384767611feee5ef5d6871e1a1b2294f7b1fd80fb401e9b888a418f4f9
# Upstream is transitioning release tags from CalVer to SemVer. Keep updates
# manual until one stable tag scheme can be expressed without a second version
# authority in this recipe.
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="bash, ca-certificates, curl, gh, git, nodejs | nodejs-lts, npm, python, python-cryptography, python-jiter, python-pillow, python-pip, python-psutil, python-pydantic-core, python-rpds-py, ripgrep, uv"
TERMUX_PKG_SUGGESTS="ffmpeg"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="setuptools"

# Hermes itself is shipped as its official source tree because upstream blocks
# wheels/sdists: those artifacts intentionally omit runtime assets. Termux's
# standard Python debscript support installs the Python runtime dependencies.
# Native cryptography/Pillow/psutil are provided by Termux packages above.
TERMUX_PKG_PYTHON_RUNTIME_DEPS="'openai==2.24.0', 'certifi==2026.5.20', 'python-dotenv==1.2.2', 'fire==0.7.1', 'httpx[socks]==0.28.1', 'rich==14.3.3', 'tenacity==9.1.4', 'pyyaml==6.0.3', 'ruamel.yaml==0.18.17', 'requests==2.33.0', 'jinja2==3.1.6', 'pydantic==2.13.4', 'prompt_toolkit==3.0.52', 'croniter==6.0.0', 'packaging==26.0', 'Markdown==3.10.2', 'PyJWT[crypto]==2.13.0', 'urllib3>=2.7.0,<3', 'websockets==15.0.1', 'pathspec==1.1.1', 'fastapi>=0.104.0,<1', 'uvicorn>=0.24.0,<1', 'python-multipart>=0.0.9,<1', 'ptyprocess>=0.7.0,<1', 'python-telegram-bot[webhooks]==22.8', 'mcp==1.28.1', 'starlette==1.3.1', 'honcho-ai==2.2.0', 'agent-client-protocol==0.9.0'"

termux_step_make() {
	termux_setup_nodejs
	local npm_cli="$TERMUX_PREFIX/lib/node_modules/npm/bin/npm-cli.js"
	test -f "$npm_cli" || termux_error_exit "Termux npm CLI is unavailable"

	# Build only the two JavaScript surfaces used at runtime. The upstream
	# lockfile remains the dependency authority; install scripts are unnecessary
	# for these pure frontend builds.
	node "$npm_cli" ci --ignore-scripts --no-audit --no-fund --fetch-retries=5 \
		--workspace web \
		--workspace ui-tui \
		--workspace ui-tui/packages/hermes-ink \
		--workspace apps/shared \
		--include-workspace-root=false
	node "$npm_cli" run build --workspace web
	node "$npm_cli" run build --workspace ui-tui

	test -f hermes_cli/web_dist/index.html || \
		termux_error_exit "Hermes web bundle was not produced"
	test -f ui-tui/dist/entry.js || \
		termux_error_exit "Hermes TUI bundle was not produced"
}

termux_step_make_install() {
	local app="$TERMUX_PREFIX/share/hermes-agent"
	local pyhome="$TERMUX_PREFIX/lib/python$TERMUX_PYTHON_VERSION/site-packages"

	rm -rf "$app"
	mkdir -p "$app" "$pyhome"

	# Python/runtime source directories. Keep the source-checkout layout because
	# Hermes resolves project assets relative to hermes_cli/config.py.
	local dir
	for dir in \
		acp_adapter agent assets cron gateway hermes_cli locales native \
		optional-mcps optional-skills plugins providers scripts skills tools \
		tui_gateway; do
		cp -a "$TERMUX_PKG_SRCDIR/$dir" "$app/"
	done

	# The TUI is prebuilt at package build time; its TypeScript sources and
	# node_modules are not runtime payload.
	mkdir -p "$app/ui-tui"
	cp -a "$TERMUX_PKG_SRCDIR/ui-tui/dist" "$app/ui-tui/"

	# Hermes also has top-level Python modules imported by the packaged source.
	find "$TERMUX_PKG_SRCDIR" -maxdepth 1 -type f -name '*.py' \
		-exec cp -a -t "$app" {} +
	install -Dm600 "$TERMUX_PKG_SRCDIR/constraints-termux.txt" \
		"$app/constraints-termux.txt"
	install -Dm600 "$TERMUX_PKG_SRCDIR/pyproject.toml" "$app/pyproject.toml"
	install -Dm600 "$TERMUX_PKG_SRCDIR/LICENSE" "$app/LICENSE"

	# Preserve upstream Python distribution identity without installing a wheel.
	# A few runtime integrations query importlib.metadata.version("hermes-agent")
	# for their User-Agent strings. Upstream intentionally blocks wheel/sdist
	# builds because those artifacts omit runtime assets, but its egg_info command
	# is metadata-only and remains supported for source/editable layouts.
	local egg_base="$TERMUX_PKG_TMPDIR/hermes-egg-info"
	rm -rf "$egg_base"
	mkdir -p "$egg_base"
	(
		cd "$TERMUX_PKG_SRCDIR"
		build-python setup.py egg_info --egg-base "$egg_base"
	)
	test -f "$egg_base/hermes_agent.egg-info/PKG-INFO" || \
		termux_error_exit "Hermes Python package metadata was not generated"
	cp -a "$egg_base/hermes_agent.egg-info" "$pyhome/"

	# Make the packaged source importable by the system Termux Python without a
	# private interpreter or private site-packages tree.
	printf '%s\n' "$app" > "$pyhome/hermes-agent.pth"
	printf 'apt\n' > "$app/.install_method"

	mkdir -p "$TERMUX_PREFIX/bin"
	# Reusable Termux build prefixes may contain stale symlinks from an older
	# Hermes package. Remove all launcher paths before redirection so writing one
	# entry point can never follow a stale alias and overwrite another launcher.
	rm -f "$TERMUX_PREFIX/bin/hermes" "$TERMUX_PREFIX/bin/hermes-agent" "$TERMUX_PREFIX/bin/hermes-acp"
	cat > "$TERMUX_PREFIX/bin/hermes" <<-EOF
	#!$TERMUX_PREFIX/bin/sh
	export HERMES_TUI_DIR="$app/ui-tui/dist"
	export HERMES_WEB_DIST="$app/hermes_cli/web_dist"
	exec "$TERMUX_PREFIX/bin/python" -m hermes_cli.main "\$@"
	EOF
	chmod 0700 "$TERMUX_PREFIX/bin/hermes"

	cat > "$TERMUX_PREFIX/bin/hermes-agent" <<-EOF
	#!$TERMUX_PREFIX/bin/sh
	export HERMES_TUI_DIR="$app/ui-tui/dist"
	export HERMES_WEB_DIST="$app/hermes_cli/web_dist"
	exec "$TERMUX_PREFIX/bin/python" -m run_agent "\$@"
	EOF
	chmod 0700 "$TERMUX_PREFIX/bin/hermes-agent"

	cat > "$TERMUX_PREFIX/bin/hermes-acp" <<-EOF
	#!$TERMUX_PREFIX/bin/sh
	export HERMES_TUI_DIR="$app/ui-tui/dist"
	export HERMES_WEB_DIST="$app/hermes_cli/web_dist"
	exec "$TERMUX_PREFIX/bin/python" -m acp_adapter.entry "\$@"
	EOF
	chmod 0700 "$TERMUX_PREFIX/bin/hermes-acp"
}
