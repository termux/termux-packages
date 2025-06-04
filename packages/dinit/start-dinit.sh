export DINIT_SOCKET_PATH="$PREFIX/var/run/dinitctl"
start-stop-daemon -S -x "$PREFIX/bin/dinit" -b -- -d "$PREFIX/etc/dinit.d" -p "$PREFIX/var/run/dinitctl"
