TERMUX_PKG_HOMEPAGE=https://github.com/lev73748/akg
TERMUX_PKG_DESCRIPTION="A fast, multi-threaded package manager for Termux written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="lev73748 <lev384501@gmail.com>"
TERMUX_PKG_VERSION=0.5.4
# Ссылка изменена под проверенный вами формат архива
TERMUX_PKG_SRCURL=https://github.com{TERMUX_PKG_VERSION}.tar.gz
# Вставлен точный SHA256 из вашего терминала
TERMUX_PKG_SHA256=d43be335d0fcb4b67adbf89ce6385faf140a9f992ca98020ce30cf6807eba5d8

# Автоматически настраивает Cargo-окружение для кросс-компиляции в Termux
TERMUX_PKG_BUILD_IN_SRC=true

# Указываем рантайм-зависимости
TERMUX_PKG_DEPENDS="gpgv, make-guile"

termux_step_make() {
    # Сборка бинарника под целевую архитектуру Android с флагом --release
    cargo build --jobs "$TERMUX_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
    # Корректное копирование скомпилированного файла в системный префикс Termux
    install -Dm755 target/"$CARGO_TARGET_NAME"/release/akg "$TERMUX_PREFIX"/bin/akg
}
