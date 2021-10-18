/*
 *  hook.c
 *
 *  Copyright (c) 2015-2021 Pacman Development Team <pacman-dev@archlinux.org>
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

#include <dirent.h>
#include <errno.h>
#include <limits.h>
#include <string.h>

#include "handle.h"
#include "hook.h"
#include "ini.h"
#include "log.h"
#include "trans.h"
#include "util.h"

enum _alpm_hook_op_t {
	ALPM_HOOK_OP_INSTALL = (1 << 0),
	ALPM_HOOK_OP_UPGRADE = (1 << 1),
	ALPM_HOOK_OP_REMOVE = (1 << 2),
};

enum _alpm_trigger_type_t {
	ALPM_HOOK_TYPE_PACKAGE = 1,
	ALPM_HOOK_TYPE_PATH,
};

struct _alpm_trigger_t {
	enum _alpm_hook_op_t op;
	enum _alpm_trigger_type_t type;
	alpm_list_t *targets;
};

struct _alpm_hook_t {
	char *name;
	char *desc;
	alpm_list_t *triggers;
	alpm_list_t *depends;
	char **cmd;
	alpm_list_t *matches;
	alpm_hook_when_t when;
	int abort_on_fail, needs_targets;
};

struct _alpm_hook_cb_ctx {
	alpm_handle_t *handle;
	struct _alpm_hook_t *hook;
};

static void _alpm_trigger_free(struct _alpm_trigger_t *trigger)
{
	if(trigger) {
		FREELIST(trigger->targets);
		free(trigger);
	}
}

static void _alpm_hook_free(struct _alpm_hook_t *hook)
{
	if(hook) {
		free(hook->name);
		free(hook->desc);
		wordsplit_free(hook->cmd);
		alpm_list_free_inner(hook->triggers, (alpm_list_fn_free) _alpm_trigger_free);
		alpm_list_free(hook->triggers);
		alpm_list_free(hook->matches);
		FREELIST(hook->depends);
		free(hook);
	}
}

static int _alpm_trigger_validate(alpm_handle_t *handle,
		struct _alpm_trigger_t *trigger, const char *file)
{
	int ret = 0;

	if(trigger->targets == NULL) {
		ret = -1;
		_alpm_log(handle, ALPM_LOG_ERROR,
				_("Missing trigger targets in hook: %s\n"), file);
	}

	if(trigger->type == 0) {
		ret = -1;
		_alpm_log(handle, ALPM_LOG_ERROR,
				_("Missing trigger type in hook: %s\n"), file);
	}

	if(trigger->op == 0) {
		ret = -1;
		_alpm_log(handle, ALPM_LOG_ERROR,
				_("Missing trigger operation in hook: %s\n"), file);
	}

	return ret;
}

static int _alpm_hook_validate(alpm_handle_t *handle,
		struct _alpm_hook_t *hook, const char *file)
{
	alpm_list_t *i;
	int ret = 0;

	if(hook->triggers == NULL) {
		/* special case: allow triggerless hooks as a way of creating dummy
		 * hooks that can be used to mask lower priority hooks */
		return 0;
	}

	for(i = hook->triggers; i; i = i->next) {
		if(_alpm_trigger_validate(handle, i->data, file) != 0) {
			ret = -1;
		}
	}

	if(hook->cmd == NULL) {
		ret = -1;
		_alpm_log(handle, ALPM_LOG_ERROR,
				_("Missing Exec option in hook: %s\n"), file);
	}

	if(hook->when == 0) {
		ret = -1;
		_alpm_log(handle, ALPM_LOG_ERROR,
				_("Missing When option in hook: %s\n"), file);
	} else if(hook->when != ALPM_HOOK_PRE_TRANSACTION && hook->abort_on_fail) {
		_alpm_log(handle, ALPM_LOG_WARNING,
				_("AbortOnFail set for PostTransaction hook: %s\n"), file);
	}

	return ret;
}

static int _alpm_hook_parse_cb(const char *file, int line,
		const char *section, char *key, char *value, void *data)
{
	struct _alpm_hook_cb_ctx *ctx = data;
	alpm_handle_t *handle = ctx->handle;
	struct _alpm_hook_t *hook = ctx->hook;

#define error(...) _alpm_log(handle, ALPM_LOG_ERROR, __VA_ARGS__); return 1;
#define warning(...) _alpm_log(handle, ALPM_LOG_WARNING, __VA_ARGS__);

	if(!section && !key) {
		error(_("error while reading hook %s: %s\n"), file, strerror(errno));
	} else if(!section) {
		error(_("hook %s line %d: invalid option %s\n"), file, line, key);
	} else if(!key) {
		/* beginning a new section */
		if(strcmp(section, "Trigger") == 0) {
			struct _alpm_trigger_t *t;
			CALLOC(t, sizeof(struct _alpm_trigger_t), 1, return 1);
			hook->triggers = alpm_list_add(hook->triggers, t);
		} else if(strcmp(section, "Action") == 0) {
			/* no special processing required */
		} else {
			error(_("hook %s line %d: invalid section %s\n"), file, line, section);
		}
	} else if(strcmp(section, "Trigger") == 0) {
		struct _alpm_trigger_t *t = hook->triggers->prev->data;
		if(strcmp(key, "Operation") == 0) {
			if(strcmp(value, "Install") == 0) {
				t->op |= ALPM_HOOK_OP_INSTALL;
			} else if(strcmp(value, "Upgrade") == 0) {
				t->op |= ALPM_HOOK_OP_UPGRADE;
			} else if(strcmp(value, "Remove") == 0) {
				t->op |= ALPM_HOOK_OP_REMOVE;
			} else {
				error(_("hook %s line %d: invalid value %s\n"), file, line, value);
			}
		} else if(strcmp(key, "Type") == 0) {
			if(t->type != 0) {
				warning(_("hook %s line %d: overwriting previous definition of %s\n"), file, line, "Type");
			}
			if(strcmp(value, "Package") == 0) {
				t->type = ALPM_HOOK_TYPE_PACKAGE;
			} else if(strcmp(value, "File") == 0) {
				_alpm_log(handle, ALPM_LOG_DEBUG,
						"File targets are deprecated, use Path instead\n");
				t->type = ALPM_HOOK_TYPE_PATH;
			} else if(strcmp(value, "Path") == 0) {
				t->type = ALPM_HOOK_TYPE_PATH;
			} else {
				error(_("hook %s line %d: invalid value %s\n"), file, line, value);
			}
		} else if(strcmp(key, "Target") == 0) {
			char *val;
			STRDUP(val, value, return 1);
			t->targets = alpm_list_add(t->targets, val);
		} else {
			error(_("hook %s line %d: invalid option %s\n"), file, line, key);
		}
	} else if(strcmp(section, "Action") == 0) {
		if(strcmp(key, "When") == 0) {
			if(hook->when != 0) {
				warning(_("hook %s line %d: overwriting previous definition of %s\n"), file, line, "When");
			}
			if(strcmp(value, "PreTransaction") == 0) {
				hook->when = ALPM_HOOK_PRE_TRANSACTION;
			} else if(strcmp(value, "PostTransaction") == 0) {
				hook->when = ALPM_HOOK_POST_TRANSACTION;
			} else {
				error(_("hook %s line %d: invalid value %s\n"), file, line, value);
			}
		} else if(strcmp(key, "Description") == 0) {
			if(hook->desc != NULL) {
				warning(_("hook %s line %d: overwriting previous definition of %s\n"), file, line, "Description");
				FREE(hook->desc);
			}
			STRDUP(hook->desc, value, return 1);
		} else if(strcmp(key, "Depends") == 0) {
			char *val;
			STRDUP(val, value, return 1);
			hook->depends = alpm_list_add(hook->depends, val);
		} else if(strcmp(key, "AbortOnFail") == 0) {
			hook->abort_on_fail = 1;
		} else if(strcmp(key, "NeedsTargets") == 0) {
			hook->needs_targets = 1;
		} else if(strcmp(key, "Exec") == 0) {
			if(hook->cmd != NULL) {
				warning(_("hook %s line %d: overwriting previous definition of %s\n"), file, line, "Exec");
				wordsplit_free(hook->cmd);
			}
			if((hook->cmd = wordsplit(value)) == NULL) {
				if(errno == EINVAL) {
					error(_("hook %s line %d: invalid value %s\n"), file, line, value);
				} else {
					error(_("hook %s line %d: unable to set option (%s)\n"),
							file, line, strerror(errno));
				}
			}
		} else {
			error(_("hook %s line %d: invalid option %s\n"), file, line, key);
		}
	}

#undef error
#undef warning

	return 0;
}

static int _alpm_hook_trigger_match_file(alpm_handle_t *handle,
		struct _alpm_hook_t *hook, struct _alpm_trigger_t *t)
{
	alpm_list_t *i, *j, *install = NULL, *upgrade = NULL, *remove = NULL;
	size_t isize = 0, rsize = 0;
	int ret = 0;

	/* check if file will be installed */
	for(i = handle->trans->add; i; i = i->next) {
		alpm_pkg_t *pkg = i->data;
		alpm_filelist_t filelist = pkg->files;
		size_t f;
		for(f = 0; f < filelist.count; f++) {
			if(alpm_option_match_noextract(handle, filelist.files[f].name) == 0) {
				continue;
			}
			if(_alpm_fnmatch_patterns(t->targets, filelist.files[f].name) == 0) {
				install = alpm_list_add(install, filelist.files[f].name);
				isize++;
			}
		}
	}

	/* check if file will be removed due to package upgrade */
	for(i = handle->trans->add; i; i = i->next) {
		alpm_pkg_t *spkg = i->data;
		alpm_pkg_t *pkg = spkg->oldpkg;
		if(pkg) {
			alpm_filelist_t filelist = pkg->files;
			size_t f;
			for(f = 0; f < filelist.count; f++) {
				if(_alpm_fnmatch_patterns(t->targets, filelist.files[f].name) == 0) {
					remove = alpm_list_add(remove, filelist.files[f].name);
					rsize++;
				}
			}
		}
	}

	/* check if file will be removed due to package removal */
	for(i = handle->trans->remove; i; i = i->next) {
		alpm_pkg_t *pkg = i->data;
		alpm_filelist_t filelist = pkg->files;
		size_t f;
		for(f = 0; f < filelist.count; f++) {
			if(_alpm_fnmatch_patterns(t->targets, filelist.files[f].name) == 0) {
				remove = alpm_list_add(remove, filelist.files[f].name);
				rsize++;
			}
		}
	}

	i = install = alpm_list_msort(install, isize, (alpm_list_fn_cmp)strcmp);
	j = remove = alpm_list_msort(remove, rsize, (alpm_list_fn_cmp)strcmp);
	while(i) {
		while(j && strcmp(i->data, j->data) > 0) {
			j = j->next;
		}
		if(j == NULL) {
			break;
		}
		if(strcmp(i->data, j->data) == 0) {
			char *path = i->data;
			upgrade = alpm_list_add(upgrade, path);
			while(i && strcmp(i->data, path) == 0) {
				alpm_list_t *next = i->next;
				install = alpm_list_remove_item(install, i);
				free(i);
				i = next;
			}
			while(j && strcmp(j->data, path) == 0) {
				alpm_list_t *next = j->next;
				remove = alpm_list_remove_item(remove, j);
				free(j);
				j = next;
			}
		} else {
			i = i->next;
		}
	}

	ret = (t->op & ALPM_HOOK_OP_INSTALL && install)
			|| (t->op & ALPM_HOOK_OP_UPGRADE && upgrade)
			|| (t->op & ALPM_HOOK_OP_REMOVE && remove);

	if(hook->needs_targets) {
#define _save_matches(_op, _matches) \
	if(t->op & _op && _matches) { \
		hook->matches = alpm_list_join(hook->matches, _matches); \
	} else { \
		alpm_list_free(_matches); \
	}
		_save_matches(ALPM_HOOK_OP_INSTALL, install);
		_save_matches(ALPM_HOOK_OP_UPGRADE, upgrade);
		_save_matches(ALPM_HOOK_OP_REMOVE, remove);
#undef _save_matches
	} else {
		alpm_list_free(install);
		alpm_list_free(upgrade);
		alpm_list_free(remove);
	}

	return ret;
}

static int _alpm_hook_trigger_match_pkg(alpm_handle_t *handle,
		struct _alpm_hook_t *hook, struct _alpm_trigger_t *t)
{
	alpm_list_t *install = NULL, *upgrade = NULL, *remove = NULL;

	if(t->op & ALPM_HOOK_OP_INSTALL || t->op & ALPM_HOOK_OP_UPGRADE) {
		alpm_list_t *i;
		for(i = handle->trans->add; i; i = i->next) {
			alpm_pkg_t *pkg = i->data;
			if(_alpm_fnmatch_patterns(t->targets, pkg->name) == 0) {
				if(pkg->oldpkg) {
					if(t->op & ALPM_HOOK_OP_UPGRADE) {
						if(hook->needs_targets) {
							upgrade = alpm_list_add(upgrade, pkg->name);
						} else {
							return 1;
						}
					}
				} else {
					if(t->op & ALPM_HOOK_OP_INSTALL) {
						if(hook->needs_targets) {
							install = alpm_list_add(install, pkg->name);
						} else {
							return 1;
						}
					}
				}
			}
		}
	}

	if(t->op & ALPM_HOOK_OP_REMOVE) {
		alpm_list_t *i;
		for(i = handle->trans->remove; i; i = i->next) {
			alpm_pkg_t *pkg = i->data;
			if(pkg && _alpm_fnmatch_patterns(t->targets, pkg->name) == 0) {
				if(!alpm_list_find(handle->trans->add, pkg, _alpm_pkg_cmp)) {
					if(hook->needs_targets) {
						remove = alpm_list_add(remove, pkg->name);
					} else {
						return 1;
					}
				}
			}
		}
	}

	/* if we reached this point we either need the target lists or we didn't
	 * match anything and the following calls will all be no-ops */
	hook->matches = alpm_list_join(hook->matches, install);
	hook->matches = alpm_list_join(hook->matches, upgrade);
	hook->matches = alpm_list_join(hook->matches, remove);

	return install || upgrade || remove;
}

static int _alpm_hook_trigger_match(alpm_handle_t *handle,
		struct _alpm_hook_t *hook, struct _alpm_trigger_t *t)
{
	return t->type == ALPM_HOOK_TYPE_PACKAGE
		? _alpm_hook_trigger_match_pkg(handle, hook, t)
		: _alpm_hook_trigger_match_file(handle, hook, t);
}

static int _alpm_hook_triggered(alpm_handle_t *handle, struct _alpm_hook_t *hook)
{
	alpm_list_t *i;
	int ret = 0;
	for(i = hook->triggers; i; i = i->next) {
		if(_alpm_hook_trigger_match(handle, hook, i->data)) {
			if(!hook->needs_targets) {
				return 1;
			} else {
				ret = 1;
			}
		}
	}
	return ret;
}

static int _alpm_hook_cmp(struct _alpm_hook_t *h1, struct _alpm_hook_t *h2)
{
	size_t suflen = strlen(ALPM_HOOK_SUFFIX), l1, l2;
	int ret;
	l1 = strlen(h1->name) - suflen;
	l2 = strlen(h2->name) - suflen;
	/* exclude the suffixes from comparison */
	ret = strncmp(h1->name, h2->name, l1 <= l2 ? l1 : l2);
	if(ret == 0 && l1 != l2) {
		return l1 < l2 ? -1 : 1;
	}
	return ret;
}

static alpm_list_t *find_hook(alpm_list_t *haystack, const void *needle)
{
	while(haystack) {
		struct _alpm_hook_t *h = haystack->data;
		if(h && strcmp(h->name, needle) == 0) {
			return haystack;
		}
		haystack = haystack->next;
	}
	return NULL;
}

static ssize_t _alpm_hook_feed_targets(char *buf, ssize_t needed, alpm_list_t **pos)
{
	size_t remaining = needed, written = 0;;
	size_t len;

	while(*pos && (len = strlen((*pos)->data)) + 1 <= remaining) {
		memcpy(buf, (*pos)->data, len);
		buf[len++] = '\n';
		*pos = (*pos)->next;
		buf += len;
		remaining -= len;
		written += len;
	}

	if(*pos && remaining) {
		memcpy(buf, (*pos)->data, remaining);
		(*pos)->data = (char*) (*pos)->data + remaining;
		written += remaining;
	}

	return written;
}

static alpm_list_t *_alpm_strlist_dedup(alpm_list_t *list)
{
	alpm_list_t *i = list;
	while(i) {
		alpm_list_t *next = i->next;
		while(next && strcmp(i->data, next->data) == 0) {
			list = alpm_list_remove_item(list, next);
			free(next);
			next = i->next;
		}
		i = next;
	}
	return list;
}

static int _alpm_hook_run_hook(alpm_handle_t *handle, struct _alpm_hook_t *hook)
{
	alpm_list_t *i, *pkgs = _alpm_db_get_pkgcache(handle->db_local);

	for(i = hook->depends; i; i = i->next) {
		if(!alpm_find_satisfier(pkgs, i->data)) {
			_alpm_log(handle, ALPM_LOG_ERROR, _("unable to run hook %s: %s\n"),
					hook->name, _("could not satisfy dependencies"));
			return -1;
		}
	}

	if(hook->needs_targets) {
		alpm_list_t *ctx;
		hook->matches = alpm_list_msort(hook->matches,
				alpm_list_count(hook->matches), (alpm_list_fn_cmp)strcmp);
		/* hooks with multiple triggers could have duplicate matches */
		ctx = hook->matches = _alpm_strlist_dedup(hook->matches);
		return _alpm_run_chroot(handle, hook->cmd[0], hook->cmd,
				(_alpm_cb_io) _alpm_hook_feed_targets, &ctx);
	} else {
		return _alpm_run_chroot(handle, hook->cmd[0], hook->cmd, NULL, NULL);
	}
}

int _alpm_hook_run(alpm_handle_t *handle, alpm_hook_when_t when)
{
	alpm_event_hook_t event = { .when = when };
	alpm_event_hook_run_t hook_event;
	alpm_list_t *i, *hooks = NULL, *hooks_triggered = NULL;
	size_t suflen = strlen(ALPM_HOOK_SUFFIX), triggered = 0;
	int ret = 0;

	for(i = alpm_list_last(handle->hookdirs); i; i = alpm_list_previous(i)) {
		char path[PATH_MAX];
		size_t dirlen;
		struct dirent *entry;
		DIR *d;

		if((dirlen = strlen(i->data)) >= PATH_MAX) {
			_alpm_log(handle, ALPM_LOG_ERROR, _("could not open directory: %s: %s\n"),
					(char *)i->data, strerror(ENAMETOOLONG));
			ret = -1;
			continue;
		}
		memcpy(path, i->data, dirlen + 1);

		if(!(d = opendir(path))) {
			if(errno == ENOENT) {
				continue;
			} else {
				_alpm_log(handle, ALPM_LOG_ERROR,
						_("could not open directory: %s: %s\n"), path, strerror(errno));
				ret = -1;
				continue;
			}
		}

		while((errno = 0, entry = readdir(d))) {
			struct _alpm_hook_cb_ctx ctx = { handle, NULL };
			struct stat buf;
			size_t name_len;

			if(strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
				continue;
			}

			if((name_len = strlen(entry->d_name)) >= PATH_MAX - dirlen) {
				_alpm_log(handle, ALPM_LOG_ERROR, _("could not open file: %s%s: %s\n"),
						path, entry->d_name, strerror(ENAMETOOLONG));
				ret = -1;
				continue;
			}
			memcpy(path + dirlen, entry->d_name, name_len + 1);

			if(name_len < suflen
					|| strcmp(entry->d_name + name_len - suflen, ALPM_HOOK_SUFFIX) != 0) {
				_alpm_log(handle, ALPM_LOG_DEBUG, "skipping non-hook file %s\n", path);
				continue;
			}

			if(find_hook(hooks, entry->d_name)) {
				_alpm_log(handle, ALPM_LOG_DEBUG, "skipping overridden hook %s\n", path);
				continue;
			}

			if(stat(path, &buf) != 0) {
				_alpm_log(handle, ALPM_LOG_ERROR,
						_("could not stat file %s: %s\n"), path, strerror(errno));
				ret = -1;
				continue;
			}

			if(S_ISDIR(buf.st_mode)) {
				_alpm_log(handle, ALPM_LOG_DEBUG, "skipping directory %s\n", path);
				continue;
			}

			CALLOC(ctx.hook, sizeof(struct _alpm_hook_t), 1,
					ret = -1; closedir(d); goto cleanup);

			_alpm_log(handle, ALPM_LOG_DEBUG, "parsing hook file %s\n", path);
			if(parse_ini(path, _alpm_hook_parse_cb, &ctx) != 0
					|| _alpm_hook_validate(handle, ctx.hook, path)) {
				_alpm_log(handle, ALPM_LOG_DEBUG, "parsing hook file %s failed\n", path);
				_alpm_hook_free(ctx.hook);
				ret = -1;
				continue;
			}

			STRDUP(ctx.hook->name, entry->d_name, ret = -1; closedir(d); goto cleanup);
			hooks = alpm_list_add(hooks, ctx.hook);
		}
		if(errno != 0) {
			_alpm_log(handle, ALPM_LOG_ERROR, _("could not read directory: %s: %s\n"),
					(char *) i->data, strerror(errno));
			ret = -1;
		}

		closedir(d);
	}

	if(ret != 0 && when == ALPM_HOOK_PRE_TRANSACTION) {
		goto cleanup;
	}

	hooks = alpm_list_msort(hooks, alpm_list_count(hooks),
			(alpm_list_fn_cmp)_alpm_hook_cmp);

	for(i = hooks; i; i = i->next) {
		struct _alpm_hook_t *hook = i->data;
		if(hook && hook->when == when && _alpm_hook_triggered(handle, hook)) {
			hooks_triggered = alpm_list_add(hooks_triggered, hook);
			triggered++;
		}
	}

	if(hooks_triggered != NULL) {
		event.type = ALPM_EVENT_HOOK_START;
		EVENT(handle, (void *)&event);

		hook_event.position = 1;
		hook_event.total = triggered;

		for(i = hooks_triggered; i; i = i->next, hook_event.position++) {
			struct _alpm_hook_t *hook = i->data;
			alpm_logaction(handle, ALPM_CALLER_PREFIX, "running '%s'...\n", hook->name);

			hook_event.type = ALPM_EVENT_HOOK_RUN_START;
			hook_event.name = hook->name;
			hook_event.desc = hook->desc;
			EVENT(handle, &hook_event);

			if(_alpm_hook_run_hook(handle, hook) != 0 && hook->abort_on_fail) {
				ret = -1;
			}

			hook_event.type = ALPM_EVENT_HOOK_RUN_DONE;
			EVENT(handle, &hook_event);

			if(ret != 0 && when == ALPM_HOOK_PRE_TRANSACTION) {
				break;
			}
		}

		alpm_list_free(hooks_triggered);

		event.type = ALPM_EVENT_HOOK_DONE;
		EVENT(handle, (void *)&event);
	}

cleanup:
	alpm_list_free_inner(hooks, (alpm_list_fn_free) _alpm_hook_free);
	alpm_list_free(hooks);

	return ret;
}
