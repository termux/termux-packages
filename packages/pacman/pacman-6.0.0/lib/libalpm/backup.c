/*
 *  backup.c
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2005 by Judd Vinet <jvinet@zeroflux.org>
 *  Copyright (c) 2005 by Aurelien Foret <orelien@chez.com>
 *  Copyright (c) 2005 by Christian Hamar <krics@linuxforum.hu>
 *  Copyright (c) 2006 by Miklos Vajna <vmiklos@frugalware.org>
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

#include <stdlib.h>
#include <string.h>

/* libalpm */
#include "backup.h"
#include "alpm_list.h"
#include "log.h"
#include "util.h"

/* split a backup string "file\thash" into the relevant components */
int _alpm_split_backup(const char *string, alpm_backup_t **backup)
{
	char *str, *ptr;

	STRDUP(str, string, return -1);

	/* tab delimiter */
	ptr = str ? strchr(str, '\t') : NULL;
	if(ptr == NULL) {
		(*backup)->name = str;
		(*backup)->hash = NULL;
		return 0;
	}
	*ptr = '\0';
	ptr++;
	/* now str points to the filename and ptr points to the hash */
	STRDUP((*backup)->name, str, FREE(str); return -1);
	STRDUP((*backup)->hash, ptr, FREE((*backup)->name); FREE(str); return -1);
	FREE(str);
	return 0;
}

/* Look for a filename in a alpm_pkg_t.backup list. If we find it,
 * then we return the full backup entry.
 */
alpm_backup_t *_alpm_needbackup(const char *file, alpm_pkg_t *pkg)
{
	const alpm_list_t *lp;

	if(file == NULL || pkg == NULL) {
		return NULL;
	}

	for(lp = alpm_pkg_get_backup(pkg); lp; lp = lp->next) {
		alpm_backup_t *backup = lp->data;

		if(strcmp(file, backup->name) == 0) {
			return backup;
		}
	}

	return NULL;
}

void _alpm_backup_free(alpm_backup_t *backup)
{
	ASSERT(backup != NULL, return);
	FREE(backup->name);
	FREE(backup->hash);
	FREE(backup);
}

alpm_backup_t *_alpm_backup_dup(const alpm_backup_t *backup)
{
	alpm_backup_t *newbackup;
	CALLOC(newbackup, 1, sizeof(alpm_backup_t), return NULL);

	STRDUP(newbackup->name, backup->name, goto error);
	STRDUP(newbackup->hash, backup->hash, goto error);

	return newbackup;

error:
	free(newbackup->name);
	free(newbackup);
	return NULL;
}
