#include <stdio.h>
#include <termios.h>

char* getpass(const char* prompt) {
	struct termios term_old, term_new;
	static char chars[256 * sizeof(int)] = { 0 }; /* fgetc() returns int */
	int len = 0, tty_changed = 0;

	printf("%s", prompt);

	if (tcgetattr(0, &term_old) == 0) {
		term_new = term_old;
		term_new.c_lflag &= ~ECHO;

		if (tcsetattr(0, TCSANOW, &term_new) == 0) {
			tty_changed = 1;
		} else {
			tty_changed = 0;
		}
	}

	while (1) {
		int c = fgetc(stdin);
		if (c == '\r' || c == '\n' || c == EOF || c == 0) break;
		chars[len++] = c;
		if (len == sizeof(chars)-1) break;
	}

	if (tty_changed) {
		(void) tcsetattr(0, TCSANOW, &term_old);
	}

	// force new line
	printf("\n");

	chars[len] = 0;

	return chars;
}
