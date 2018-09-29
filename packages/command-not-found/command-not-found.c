#include <stdio.h>
#include <string.h>
#include <stdbool.h>

char const* const commands[] = {
#ifdef __aarch64__
# include "commands-aarch64.h"
#elif defined __arm__
# include "commands-arm.h"
#elif defined __x86_64__
# include "commands-x86_64.h"
#elif defined __i686__
# include "commands-i686.h"
#else
# error Failed to detect arch
#endif
};

static inline int termux_min3(unsigned int a, unsigned int b, unsigned int c) {
	return (a < b ? (a < c ? a : c) : (b < c ? b : c));
}

static int termux_levenshtein_distance(char const* restrict s1, char const* restrict s2) {
	unsigned int s1len = strlen(s1);
	unsigned int s2len = strlen(s2);
	unsigned int matrix[s2len+1][s1len+1];
	matrix[0][0] = 0;
	for (unsigned x = 1; x <= s2len; x++)
		matrix[x][0] = matrix[x-1][0] + 1;
	for (unsigned y = 1; y <= s1len; y++)
		matrix[0][y] = matrix[0][y-1] + 1;
	for (unsigned x = 1; x <= s2len; x++)
		for (unsigned y = 1; y <= s1len; y++)
			matrix[x][y] = termux_min3(matrix[x-1][y] + 1, matrix[x][y-1] + 1, matrix[x-1][y-1] + (s1[y-1] == s2[x-1] ? 0 : 1));
	return matrix[s2len][s1len];
}

int main(int argc, char** argv) {
	if (argc != 2) {
		fprintf(stderr, "usage: termux-command-not-found <command>\n");
		return 1;
	}
	char* command_not_found = argv[1];

	int best_distance = -1;
	int guesses_at_best_distance = 0;
	char current_package[128];
	char best_package_guess[128];
	char best_command_guess[128];
	const int num_commands = sizeof(commands) / sizeof(commands[0]);
	for (int i = 0; i < num_commands; i++) {
		char const* current_line = commands[i];
		if (current_line[0] == ' ') { // Binary
			char const* binary_name = current_line + 1;
			int distance = termux_levenshtein_distance(command_not_found, binary_name);
			if (distance == 0 && strcmp(command_not_found, binary_name) == 0) {
				if (best_distance == 0) {
					fprintf(stderr, "or\n");
				} else {
					fprintf(stderr, "The program '%s' is not installed. Install it by executing:\n", binary_name);
				}
				fprintf(stderr, " pkg install %s\n", current_package);
				best_distance = 0;
			} else if (best_distance == distance) {
				guesses_at_best_distance++;
			} else if (best_distance == -1 || best_distance > distance) {
				guesses_at_best_distance = 1;
				best_distance = distance;
				strncpy(best_command_guess, binary_name, sizeof(best_command_guess));
				strncpy(best_package_guess, current_package, sizeof(best_package_guess));
			}
		} else { // Package
			strncpy(current_package, current_line, sizeof(current_package));
		}
	}

	if (best_distance == 0) return 127;

	if (best_distance == -1 || best_distance > 3) {
		fprintf(stderr, "%s: command not found\n", command_not_found);
	} else {
		fprintf(stderr, "No command '%s' found, did you mean:\n", command_not_found);
		if (guesses_at_best_distance == 1) {
			// Only one suggestion - show it:
			fprintf(stderr, " Command '%s' from package '%s'\n", best_command_guess, best_package_guess);
		} else {
			// Multiple suggestions at the same distance - show them all:
			for (int i = 0; i < num_commands; i++) {
				char const* current_line = commands[i];
				if (current_line[0] == ' ') { // Binary
					char const* binary_name = current_line + 1;
					int distance = termux_levenshtein_distance(command_not_found, binary_name);
					if (best_distance == distance) {
						fprintf(stderr, " Command '%s' from package '%s'\n", binary_name, current_package);
					}
				} else { // Package
					strncpy(current_package, current_line, sizeof(current_package));
				}
			}
		}
	}
	return 127;
}

