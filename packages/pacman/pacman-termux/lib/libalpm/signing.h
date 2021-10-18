/*
 *  signing.h
 *
 *  Copyright (c) 2008-2021 Pacman Development Team <pacman-dev@archlinux.org>
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
#ifndef ALPM_SIGNING_H
#define ALPM_SIGNING_H

#include "alpm.h"

char *_alpm_sigpath(alpm_handle_t *handle, const char *path);
int _alpm_gpgme_checksig(alpm_handle_t *handle, const char *path,
		const char *base64_sig, alpm_siglist_t *result);

int _alpm_check_pgp_helper(alpm_handle_t *handle, const char *path,
		const char *base64_sig, int optional, int marginal, int unknown,
		alpm_siglist_t **sigdata);
int _alpm_process_siglist(alpm_handle_t *handle, const char *identifier,
		alpm_siglist_t *siglist, int optional, int marginal, int unknown);

int _alpm_key_in_keychain(alpm_handle_t *handle, const char *fpr);
int _alpm_key_import(alpm_handle_t *handle, const char *uid, const char *fpr);

#endif /* ALPM_SIGNING_H */
