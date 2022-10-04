#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <sys/stat.h>
#include <wayland-client.h>

#ifndef TERMUX_PREFIX
# define TERMUX_PREFIX "/data/data/com.termux/files/usr"
#endif

#ifndef TERMUX_X11_DIR
# define TERMUX_X11_DIR "/data/data/com.termux.x11/"
#endif

int dir_exists(const char *dir) {
	struct stat sb;
	if (stat(dir, &sb) == 0 && S_ISDIR(sb.st_mode))
		return 1;
	return 0;
}

int connection_exists(void) {
	struct wl_display *d = wl_display_connect(NULL);
	if (d != NULL) {
		wl_display_disconnect(d);
		return 1;
	}

	return 0;
}

int start_server(char *argv[]) {
	switch(fork()) {
		case -1:
			// Error
			perror("fork");
			return -1;
			break;
		case 0:
			// Child
			execv(argv[0], argv);
			perror("execv");
			exit(1);
			return -1;
		default:
			//Parent
			return 0;
	}

	// Should never reach this
	return -1;
}

void start_xwayland(char *argv[]) {
	argv[0] = TERMUX_PREFIX "/bin/Xwayland";
	execv(argv[0], argv);
	perror("execv");
}

int main(int argc, char *argv[]) {
	if (!dir_exists(TERMUX_X11_DIR)) {
		printf("Termux:X11 is not installed\n");
		return 1;
	}

	char *server_argv[] = {TERMUX_PREFIX "/bin/am", "start", "-n", "com.termux.x11/.MainActivity", NULL};

	if (!connection_exists()) {
		if (start_server(server_argv) == -1) {
			printf("Error starting Termux:X11\n");
			return 1;
		}
	}

	int e = 0, i = 0;
	while(i++ < 10) {
		if ((e = connection_exists())) {
			start_xwayland(argv);
			break;
		}

		sleep(1);
	}

	printf("Failed starting Termux:X11: timeout\n");

	return 1;
}
