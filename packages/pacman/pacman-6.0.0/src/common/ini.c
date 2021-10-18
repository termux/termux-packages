/*
 *  ini.c
 *
 *  Copyright (c) 2013-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <errno.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h> /* strdup */

#include "ini.h"
#include "util-common.h"

/**
 * @brief Parse a pacman-style INI config file.
 *
 * @param file path to the config file
 * @param cb callback for key/value pairs
 * @param data caller defined data to be passed to the callback
 *
 * @return the callback return value
 *
 * @note The callback will be called at the beginning of each section with an
 * empty key and value and for each key/value pair.
 *
 * @note If the parser encounters an error the callback will be called with
 * section, key, and value set to NULL and errno set by fopen, fgets, or
 * strdup.
 *
 * @note The @a key and @a value passed to @ cb will be overwritten between
 * calls.  The section name will remain valid until after @a cb is called to
 * begin a new section.
 *
 * @note Parsing will immediately stop if the callback returns non-zero.
 */
int parse_ini(const char *file, ini_parser_fn cb, void *data)
{
	char line[PATH_MAX], *section_name = NULL;
	FILE *fp = NULL;
	int linenum = 0;
	int ret = 0;

	fp = fopen(file, "r");
	if(fp == NULL) {
		return cb(file, 0, NULL, NULL, NULL, data);
	}

	while(safe_fgets(line, PATH_MAX, fp)) {
		char *key, *value;
		size_t line_len;

		linenum++;

		line_len = strtrim(line);

		if(line_len == 0 || line[0] == '#') {
			continue;
		}

		if(line[0] == '[' && line[line_len - 1] == ']') {
			char *name;
			/* new config section, skip the '[' */
			name = strdup(line + 1);
			name[line_len - 2] = '\0';

			ret = cb(file, linenum, name, NULL, NULL, data);
			free(section_name);
			section_name = name;

			/* we're at a new section; perform any post-actions for the prior */
			if(ret) {
				goto cleanup;
			}
			continue;
		}

		/* directive */
		/* strsep modifies the 'line' string: 'key \0 value' */
		key = line;
		value = line;
		strsep(&value, "=");
		strtrim(key);
		strtrim(value);

		if((ret = cb(file, linenum, section_name, key, value, data)) != 0) {
			goto cleanup;
		}
	}

cleanup:
	fclose(fp);
	free(section_name);
	return ret;
}
