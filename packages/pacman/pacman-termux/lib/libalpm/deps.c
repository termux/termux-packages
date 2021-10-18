/*
 *  deps.c
 *
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *  Copyright (c) 2002-2006 by Judd Vinet <jvinet@zeroflux.org>
 *  Copyright (c) 2005 by Aurelien Foret <orelien@chez.com>
 *  Copyright (c) 2005, 2006 by Miklos Vajna <vmiklos@frugalware.org>
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
#include <stdio.h>
#include <string.h>

/* libalpm */
#include "deps.h"
#include "alpm_list.h"
#include "util.h"
#include "log.h"
#include "graph.h"
#include "package.h"
#include "db.h"
#include "handle.h"
#include "trans.h"

void SYMEXPORT alpm_dep_free(alpm_depend_t *dep)
{
	ASSERT(dep != NULL, return);
	FREE(dep->name);
	FREE(dep->version);
	FREE(dep->desc);
	FREE(dep);
}

static alpm_depmissing_t *depmiss_new(const char *target, alpm_depend_t *dep,
		const char *causingpkg)
{
	alpm_depmissing_t *miss;

	CALLOC(miss, 1, sizeof(alpm_depmissing_t), return NULL);

	STRDUP(miss->target, target, goto error);
	miss->depend = _alpm_dep_dup(dep);
	STRDUP(miss->causingpkg, causingpkg, goto error);

	return miss;

error:
	alpm_depmissing_free(miss);
	return NULL;
}

void SYMEXPORT alpm_depmissing_free(alpm_depmissing_t *miss)
{
	ASSERT(miss != NULL, return);
	alpm_dep_free(miss->depend);
	FREE(miss->target);
	FREE(miss->causingpkg);
	FREE(miss);
}

/** Check if pkg2 satisfies a dependency of pkg1 */
static int _alpm_pkg_depends_on(alpm_pkg_t *pkg1, alpm_pkg_t *pkg2)
{
	alpm_list_t *i;
	for(i = alpm_pkg_get_depends(pkg1); i; i = i->next) {
		if(_alpm_depcmp(pkg2, i->data)) {
			return 1;
		}
	}
	return 0;
}

static alpm_pkg_t *find_dep_satisfier(alpm_list_t *pkgs, alpm_depend_t *dep)
{
	alpm_list_t *i;

	for(i = pkgs; i; i = i->next) {
		alpm_pkg_t *pkg = i->data;
		if(_alpm_depcmp(pkg, dep)) {
			return pkg;
		}
	}
	return NULL;
}

/* Convert a list of alpm_pkg_t * to a graph structure,
 * with a edge for each dependency.
 * Returns a list of vertices (one vertex = one package)
 * (used by alpm_sortbydeps)
 */
static alpm_list_t *dep_graph_init(alpm_handle_t *handle,
		alpm_list_t *targets, alpm_list_t *ignore)
{
	alpm_list_t *i, *j;
	alpm_list_t *vertices = NULL;
	alpm_list_t *localpkgs = alpm_list_diff(
			alpm_db_get_pkgcache(handle->db_local), targets, _alpm_pkg_cmp);

	if(ignore) {
		alpm_list_t *oldlocal = localpkgs;
		localpkgs = alpm_list_diff(oldlocal, ignore, _alpm_pkg_cmp);
		alpm_list_free(oldlocal);
	}

	/* We create the vertices */
	for(i = targets; i; i = i->next) {
		alpm_graph_t *vertex = _alpm_graph_new();
		vertex->data = (void *)i->data;
		vertices = alpm_list_add(vertices, vertex);
	}

	/* We compute the edges */
	for(i = vertices; i; i = i->next) {
		alpm_graph_t *vertex_i = i->data;
		alpm_pkg_t *p_i = vertex_i->data;
		/* TODO this should be somehow combined with alpm_checkdeps */
		for(j = vertices; j; j = j->next) {
			alpm_graph_t *vertex_j = j->data;
			alpm_pkg_t *p_j = vertex_j->data;
			if(_alpm_pkg_depends_on(p_i, p_j)) {
				vertex_i->children =
					alpm_list_add(vertex_i->children, vertex_j);
			}
		}

		/* lazily add local packages to the dep graph so they don't
		 * get resolved unnecessarily */
		j = localpkgs;
		while(j) {
			alpm_list_t *next = j->next;
			if(_alpm_pkg_depends_on(p_i, j->data)) {
				alpm_graph_t *vertex_j = _alpm_graph_new();
				vertex_j->data = (void *)j->data;
				vertices = alpm_list_add(vertices, vertex_j);
				vertex_i->children = alpm_list_add(vertex_i->children, vertex_j);
				localpkgs = alpm_list_remove_item(localpkgs, j);
				free(j);
			}
			j = next;
		}

		vertex_i->iterator = vertex_i->children;
	}
	alpm_list_free(localpkgs);
	return vertices;
}

static void _alpm_warn_dep_cycle(alpm_handle_t *handle, alpm_list_t *targets,
		alpm_graph_t *ancestor, alpm_graph_t *vertex, int reverse)
{
	/* vertex depends on and is required by ancestor */
	if(!alpm_list_find_ptr(targets, vertex->data)) {
		/* child is not part of the transaction, not a problem */
		return;
	}

	/* find the nearest ancestor that's part of the transaction */
	while(ancestor) {
		if(alpm_list_find_ptr(targets, ancestor->data)) {
			break;
		}
		ancestor = ancestor->parent;
	}

	if(!ancestor || ancestor == vertex) {
		/* no transaction package in our ancestry or the package has
		 * a circular dependency with itself, not a problem */
	} else {
		alpm_pkg_t *ancestorpkg = ancestor->data;
		alpm_pkg_t *childpkg = vertex->data;
		_alpm_log(handle, ALPM_LOG_WARNING, _("dependency cycle detected:\n"));
		if(reverse) {
			_alpm_log(handle, ALPM_LOG_WARNING,
					_("%s will be removed after its %s dependency\n"),
					ancestorpkg->name, childpkg->name);
		} else {
			_alpm_log(handle, ALPM_LOG_WARNING,
					_("%s will be installed before its %s dependency\n"),
					ancestorpkg->name, childpkg->name);
		}
	}
}

/* Re-order a list of target packages with respect to their dependencies.
 *
 * Example (reverse == 0):
 *   A depends on C
 *   B depends on A
 *   Target order is A,B,C,D
 *
 *   Should be re-ordered to C,A,B,D
 *
 * packages listed in ignore will not be used to detect indirect dependencies
 *
 * if reverse is > 0, the dependency order will be reversed.
 *
 * This function returns the new alpm_list_t* target list.
 *
 */
alpm_list_t *_alpm_sortbydeps(alpm_handle_t *handle,
		alpm_list_t *targets, alpm_list_t *ignore, int reverse)
{
	alpm_list_t *newtargs = NULL;
	alpm_list_t *vertices = NULL;
	alpm_list_t *i;
	alpm_graph_t *vertex;

	if(targets == NULL) {
		return NULL;
	}

	_alpm_log(handle, ALPM_LOG_DEBUG, "started sorting dependencies\n");

	vertices = dep_graph_init(handle, targets, ignore);

	i = vertices;
	vertex = vertices->data;
	while(i) {
		/* mark that we touched the vertex */
		vertex->state = ALPM_GRAPH_STATE_PROCESSING;
		int switched_to_child = 0;
		while(vertex->iterator && !switched_to_child) {
			alpm_graph_t *nextchild = vertex->iterator->data;
			vertex->iterator = vertex->iterator->next;
			if(nextchild->state == ALPM_GRAPH_STATE_UNPROCESSED) {
				switched_to_child = 1;
				nextchild->parent = vertex;
				vertex = nextchild;
			} else if(nextchild->state == ALPM_GRAPH_STATE_PROCESSING) {
				_alpm_warn_dep_cycle(handle, targets, vertex, nextchild, reverse);
			}
		}
		if(!switched_to_child) {
			if(alpm_list_find_ptr(targets, vertex->data)) {
				newtargs = alpm_list_add(newtargs, vertex->data);
			}
			/* mark that we've left this vertex */
			vertex->state = ALPM_GRAPH_STATE_PROCESSED;
			vertex = vertex->parent;
			if(!vertex) {
				/* top level vertex reached, move to the next unprocessed vertex */
				for(i = i->next; i; i = i->next) {
					vertex = i->data;
					if(vertex->state == ALPM_GRAPH_STATE_UNPROCESSED) {
						break;
					}
				}
			}
		}
	}

	_alpm_log(handle, ALPM_LOG_DEBUG, "sorting dependencies finished\n");

	if(reverse) {
		/* reverse the order */
		alpm_list_t *tmptargs = alpm_list_reverse(newtargs);
		/* free the old one */
		alpm_list_free(newtargs);
		newtargs = tmptargs;
	}

	alpm_list_free_inner(vertices, _alpm_graph_free);
	alpm_list_free(vertices);

	return newtargs;
}

static int no_dep_version(alpm_handle_t *handle)
{
	if(!handle->trans) {
		return 0;
	}
	return (handle->trans->flags & ALPM_TRANS_FLAG_NODEPVERSION);
}

alpm_pkg_t SYMEXPORT *alpm_find_satisfier(alpm_list_t *pkgs, const char *depstring)
{
	alpm_depend_t *dep = alpm_dep_from_string(depstring);
	if(!dep) {
		return NULL;
	}
	alpm_pkg_t *pkg = find_dep_satisfier(pkgs, dep);
	alpm_dep_free(dep);
	return pkg;
}

alpm_list_t SYMEXPORT *alpm_checkdeps(alpm_handle_t *handle,
		alpm_list_t *pkglist, alpm_list_t *rem, alpm_list_t *upgrade,
		int reversedeps)
{
	alpm_list_t *i, *j;
	alpm_list_t *dblist = NULL, *modified = NULL;
	alpm_list_t *baddeps = NULL;
	int nodepversion;

	CHECK_HANDLE(handle, return NULL);

	for(i = pkglist; i; i = i->next) {
		alpm_pkg_t *pkg = i->data;
		if(alpm_pkg_find(rem, pkg->name) || alpm_pkg_find(upgrade, pkg->name)) {
			modified = alpm_list_add(modified, pkg);
		} else {
			dblist = alpm_list_add(dblist, pkg);
		}
	}

	nodepversion = no_dep_version(handle);

	/* look for unsatisfied dependencies of the upgrade list */
	for(i = upgrade; i; i = i->next) {
		alpm_pkg_t *tp = i->data;
		_alpm_log(handle, ALPM_LOG_DEBUG, "checkdeps: package %s-%s\n",
				tp->name, tp->version);

		for(j = alpm_pkg_get_depends(tp); j; j = j->next) {
			alpm_depend_t *depend = j->data;
			alpm_depmod_t orig_mod = depend->mod;
			if(nodepversion) {
				depend->mod = ALPM_DEP_MOD_ANY;
			}
			/* 1. we check the upgrade list */
			/* 2. we check database for untouched satisfying packages */
			/* 3. we check the dependency ignore list */
			if(!find_dep_satisfier(upgrade, depend) &&
					!find_dep_satisfier(dblist, depend) &&
					!_alpm_depcmp_provides(depend, handle->assumeinstalled)) {
				/* Unsatisfied dependency in the upgrade list */
				alpm_depmissing_t *miss;
				char *missdepstring = alpm_dep_compute_string(depend);
				_alpm_log(handle, ALPM_LOG_DEBUG, "checkdeps: missing dependency '%s' for package '%s'\n",
						missdepstring, tp->name);
				free(missdepstring);
				miss = depmiss_new(tp->name, depend, NULL);
				baddeps = alpm_list_add(baddeps, miss);
			}
			depend->mod = orig_mod;
		}
	}

	if(reversedeps) {
		/* reversedeps handles the backwards dependencies, ie,
		 * the packages listed in the requiredby field. */
		for(i = dblist; i; i = i->next) {
			alpm_pkg_t *lp = i->data;
			for(j = alpm_pkg_get_depends(lp); j; j = j->next) {
				alpm_depend_t *depend = j->data;
				alpm_depmod_t orig_mod = depend->mod;
				if(nodepversion) {
					depend->mod = ALPM_DEP_MOD_ANY;
				}
				alpm_pkg_t *causingpkg = find_dep_satisfier(modified, depend);
				/* we won't break this depend, if it is already broken, we ignore it */
				/* 1. check upgrade list for satisfiers */
				/* 2. check dblist for satisfiers */
				/* 3. we check the dependency ignore list */
				if(causingpkg &&
						!find_dep_satisfier(upgrade, depend) &&
						!find_dep_satisfier(dblist, depend) &&
						!_alpm_depcmp_provides(depend, handle->assumeinstalled)) {
					alpm_depmissing_t *miss;
					char *missdepstring = alpm_dep_compute_string(depend);
					_alpm_log(handle, ALPM_LOG_DEBUG, "checkdeps: transaction would break '%s' dependency of '%s'\n",
							missdepstring, lp->name);
					free(missdepstring);
					miss = depmiss_new(lp->name, depend, causingpkg->name);
					baddeps = alpm_list_add(baddeps, miss);
				}
				depend->mod = orig_mod;
			}
		}
	}

	alpm_list_free(modified);
	alpm_list_free(dblist);

	return baddeps;
}

static int dep_vercmp(const char *version1, alpm_depmod_t mod,
		const char *version2)
{
	int equal = 0;

	if(mod == ALPM_DEP_MOD_ANY) {
		equal = 1;
	} else {
		int cmp = alpm_pkg_vercmp(version1, version2);
		switch(mod) {
			case ALPM_DEP_MOD_EQ: equal = (cmp == 0); break;
			case ALPM_DEP_MOD_GE: equal = (cmp >= 0); break;
			case ALPM_DEP_MOD_LE: equal = (cmp <= 0); break;
			case ALPM_DEP_MOD_LT: equal = (cmp < 0); break;
			case ALPM_DEP_MOD_GT: equal = (cmp > 0); break;
			default: equal = 1; break;
		}
	}
	return equal;
}

int _alpm_depcmp_literal(alpm_pkg_t *pkg, alpm_depend_t *dep)
{
	if(pkg->name_hash != dep->name_hash
			|| strcmp(pkg->name, dep->name) != 0) {
		/* skip more expensive checks */
		return 0;
	}
	return dep_vercmp(pkg->version, dep->mod, dep->version);
}

/**
 * @param dep dependency to check against the provision list
 * @param provisions provision list
 * @return 1 if provider is found, 0 otherwise
 */
int _alpm_depcmp_provides(alpm_depend_t *dep, alpm_list_t *provisions)
{
	int satisfy = 0;
	alpm_list_t *i;

	/* check provisions, name and version if available */
	for(i = provisions; i && !satisfy; i = i->next) {
		alpm_depend_t *provision = i->data;

		if(dep->mod == ALPM_DEP_MOD_ANY) {
			/* any version will satisfy the requirement */
			satisfy = (provision->name_hash == dep->name_hash
					&& strcmp(provision->name, dep->name) == 0);
		} else if(provision->mod == ALPM_DEP_MOD_EQ) {
			/* provision specifies a version, so try it out */
			satisfy = (provision->name_hash == dep->name_hash
					&& strcmp(provision->name, dep->name) == 0
					&& dep_vercmp(provision->version, dep->mod, dep->version));
		}
	}

	return satisfy;
}

int _alpm_depcmp(alpm_pkg_t *pkg, alpm_depend_t *dep)
{
	return _alpm_depcmp_literal(pkg, dep)
		|| _alpm_depcmp_provides(dep, alpm_pkg_get_provides(pkg));
}

alpm_depend_t SYMEXPORT *alpm_dep_from_string(const char *depstring)
{
	alpm_depend_t *depend;
	const char *ptr, *version, *desc;
	size_t deplen;

	if(depstring == NULL) {
		return NULL;
	}

	CALLOC(depend, 1, sizeof(alpm_depend_t), return NULL);

	/* Note the extra space in ": " to avoid matching the epoch */
	if((desc = strstr(depstring, ": ")) != NULL) {
		STRDUP(depend->desc, desc + 2, goto error);
		deplen = desc - depstring;
	} else {
		/* no description- point desc at NULL at end of string for later use */
		depend->desc = NULL;
		deplen = strlen(depstring);
		desc = depstring + deplen;
	}

	/* Find a version comparator if one exists. If it does, set the type and
	 * increment the ptr accordingly so we can copy the right strings. */
	if((ptr = memchr(depstring, '<', deplen))) {
		if(ptr[1] == '=') {
			depend->mod = ALPM_DEP_MOD_LE;
			version = ptr + 2;
		} else {
			depend->mod = ALPM_DEP_MOD_LT;
			version = ptr + 1;
		}
	} else if((ptr = memchr(depstring, '>', deplen))) {
		if(ptr[1] == '=') {
			depend->mod = ALPM_DEP_MOD_GE;
			version = ptr + 2;
		} else {
			depend->mod = ALPM_DEP_MOD_GT;
			version = ptr + 1;
		}
	} else if((ptr = memchr(depstring, '=', deplen))) {
		/* Note: we must do =,<,> checks after <=, >= checks */
		depend->mod = ALPM_DEP_MOD_EQ;
		version = ptr + 1;
	} else {
		/* no version specified, set ptr to end of string and version to NULL */
		ptr = depstring + deplen;
		depend->mod = ALPM_DEP_MOD_ANY;
		depend->version = NULL;
		version = NULL;
	}

	/* copy the right parts to the right places */
	STRNDUP(depend->name, depstring, ptr - depstring, goto error);
	depend->name_hash = _alpm_hash_sdbm(depend->name);
	if(version) {
		STRNDUP(depend->version, version, desc - version, goto error);
	}

	return depend;

error:
	alpm_dep_free(depend);
	return NULL;
}

alpm_depend_t *_alpm_dep_dup(const alpm_depend_t *dep)
{
	alpm_depend_t *newdep;
	CALLOC(newdep, 1, sizeof(alpm_depend_t), return NULL);

	STRDUP(newdep->name, dep->name, goto error);
	STRDUP(newdep->version, dep->version, goto error);
	STRDUP(newdep->desc, dep->desc, goto error);
	newdep->name_hash = dep->name_hash;
	newdep->mod = dep->mod;

	return newdep;

error:
	alpm_dep_free(newdep);
	return NULL;
}

/** Move package dependencies from one list to another
 * @param from list to scan for dependencies
 * @param to list to add dependencies to
 * @param pkg package whose dependencies are moved
 * @param explicit if 0, explicitly installed packages are not moved
 */
static void _alpm_select_depends(alpm_list_t **from, alpm_list_t **to,
		alpm_pkg_t *pkg, int explicit)
{
	alpm_list_t *i, *next;
	if(!alpm_pkg_get_depends(pkg)) {
		return;
	}
	for(i = *from; i; i = next) {
		alpm_pkg_t *deppkg = i->data;
		next = i->next;
		if((explicit || alpm_pkg_get_reason(deppkg) != ALPM_PKG_REASON_EXPLICIT)
				&& _alpm_pkg_depends_on(pkg, deppkg)) {
			*to = alpm_list_add(*to, deppkg);
			*from = alpm_list_remove_item(*from, i);
			free(i);
		}
	}
}

/**
 * @brief Adds unneeded dependencies to an existing list of packages.
 * By unneeded, we mean dependencies that are only required by packages in the
 * target list, so they can be safely removed.
 * If the input list was topo sorted, the output list will be topo sorted too.
 *
 * @param db package database to do dependency tracing in
 * @param *targs pointer to a list of packages
 * @param include_explicit if 0, explicitly installed packages are not included
 * @return 0 on success, -1 on errors
 */
int _alpm_recursedeps(alpm_db_t *db, alpm_list_t **targs, int include_explicit)
{
	alpm_list_t *i, *keep, *rem = NULL;

	if(db == NULL || targs == NULL) {
		return -1;
	}

	keep = alpm_list_copy(_alpm_db_get_pkgcache(db));
	for(i = *targs; i; i = i->next) {
		keep = alpm_list_remove(keep, i->data, _alpm_pkg_cmp, NULL);
	}

	/* recursively select all dependencies for removal */
	for(i = *targs; i; i = i->next) {
		_alpm_select_depends(&keep, &rem, i->data, include_explicit);
	}
	for(i = rem; i; i = i->next) {
		_alpm_select_depends(&keep, &rem, i->data, include_explicit);
	}

	/* recursively select any still needed packages to keep */
	for(i = keep; i && rem; i = i->next) {
		_alpm_select_depends(&rem, &keep, i->data, 1);
	}
	alpm_list_free(keep);

	/* copy selected packages into the target list */
	for(i = rem; i; i = i->next) {
		alpm_pkg_t *pkg = i->data, *copy = NULL;
		_alpm_log(db->handle, ALPM_LOG_DEBUG,
				"adding '%s' to the targets\n", pkg->name);
		if(_alpm_pkg_dup(pkg, &copy)) {
			/* we return memory on "non-fatal" error in _alpm_pkg_dup */
			_alpm_pkg_free(copy);
			alpm_list_free(rem);
			return -1;
		}
		*targs = alpm_list_add(*targs, copy);
	}
	alpm_list_free(rem);

	return 0;
}

/**
 * helper function for resolvedeps: search for dep satisfier in dbs
 *
 * @param handle the context handle
 * @param dep is the dependency to search for
 * @param dbs are the databases to search
 * @param excluding are the packages to exclude from the search
 * @param prompt if true, ask an alpm_question_install_ignorepkg_t to decide
 *        if ignored packages should be installed; if false, skip ignored
 *        packages.
 * @return the resolved package
 **/
static alpm_pkg_t *resolvedep(alpm_handle_t *handle, alpm_depend_t *dep,
		alpm_list_t *dbs, alpm_list_t *excluding, int prompt)
{
	alpm_list_t *i, *j;
	int ignored = 0;

	alpm_list_t *providers = NULL;
	int count;

	/* 1. literals */
	for(i = dbs; i; i = i->next) {
		alpm_pkg_t *pkg;
		alpm_db_t *db = i->data;

		if(!(db->usage & (ALPM_DB_USAGE_INSTALL|ALPM_DB_USAGE_UPGRADE))) {
			continue;
		}

		pkg = _alpm_db_get_pkgfromcache(db, dep->name);
		if(pkg && _alpm_depcmp_literal(pkg, dep)
				&& !alpm_pkg_find(excluding, pkg->name)) {
			if(alpm_pkg_should_ignore(handle, pkg)) {
				alpm_question_install_ignorepkg_t question = {
					.type = ALPM_QUESTION_INSTALL_IGNOREPKG,
					.install = 0,
					.pkg = pkg
				};
				if(prompt) {
					QUESTION(handle, &question);
				} else {
					_alpm_log(handle, ALPM_LOG_WARNING, _("ignoring package %s-%s\n"),
							pkg->name, pkg->version);
				}
				if(!question.install) {
					ignored = 1;
					continue;
				}
			}
			return pkg;
		}
	}
	/* 2. satisfiers (skip literals here) */
	for(i = dbs; i; i = i->next) {
		alpm_db_t *db = i->data;
		if(!(db->usage & (ALPM_DB_USAGE_INSTALL|ALPM_DB_USAGE_UPGRADE))) {
			continue;
		}
		for(j = _alpm_db_get_pkgcache(db); j; j = j->next) {
			alpm_pkg_t *pkg = j->data;
			if((pkg->name_hash != dep->name_hash || strcmp(pkg->name, dep->name) != 0)
					&& _alpm_depcmp_provides(dep, alpm_pkg_get_provides(pkg))
					&& !alpm_pkg_find(excluding, pkg->name)) {
				if(alpm_pkg_should_ignore(handle, pkg)) {
					alpm_question_install_ignorepkg_t question = {
						.type = ALPM_QUESTION_INSTALL_IGNOREPKG,
						.install = 0,
						.pkg = pkg
					};
					if(prompt) {
						QUESTION(handle, &question);
					} else {
						_alpm_log(handle, ALPM_LOG_WARNING, _("ignoring package %s-%s\n"),
								pkg->name, pkg->version);
					}
					if(!question.install) {
						ignored = 1;
						continue;
					}
				}
				_alpm_log(handle, ALPM_LOG_DEBUG, "provider found (%s provides %s)\n",
						pkg->name, dep->name);

				/* provide is already installed so return early instead of prompting later */
				if(_alpm_db_get_pkgfromcache(handle->db_local, pkg->name)) {
					alpm_list_free(providers);
					return pkg;
				}

				providers = alpm_list_add(providers, pkg);
				/* keep looking for other providers in the all dbs */
			}
		}
	}

	count = alpm_list_count(providers);
	if(count >= 1) {
		alpm_question_select_provider_t question = {
			.type = ALPM_QUESTION_SELECT_PROVIDER,
			/* default to first provider if there is no QUESTION callback */
			.use_index = 0,
			.providers = providers,
			.depend = dep
		};
		if(count > 1) {
			/* if there is more than one provider, we ask the user */
			QUESTION(handle, &question);
		}
		if(question.use_index >= 0 && question.use_index < count) {
			alpm_list_t *nth = alpm_list_nth(providers, question.use_index);
			alpm_pkg_t *pkg = nth->data;
			alpm_list_free(providers);
			return pkg;
		}
		alpm_list_free(providers);
		providers = NULL;
	}

	if(ignored) { /* resolvedeps will override these */
		handle->pm_errno = ALPM_ERR_PKG_IGNORED;
	} else {
		handle->pm_errno = ALPM_ERR_PKG_NOT_FOUND;
	}
	return NULL;
}

alpm_pkg_t SYMEXPORT *alpm_find_dbs_satisfier(alpm_handle_t *handle,
		alpm_list_t *dbs, const char *depstring)
{
	alpm_depend_t *dep;
	alpm_pkg_t *pkg;

	CHECK_HANDLE(handle, return NULL);
	ASSERT(dbs, RET_ERR(handle, ALPM_ERR_WRONG_ARGS, NULL));

	dep = alpm_dep_from_string(depstring);
	ASSERT(dep, return NULL);
	pkg = resolvedep(handle, dep, dbs, NULL, 1);
	alpm_dep_free(dep);
	return pkg;
}

/**
 * Computes resolvable dependencies for a given package and adds that package
 * and those resolvable dependencies to a list.
 *
 * @param handle the context handle
 * @param localpkgs is the list of local packages
 * @param pkg is the package to resolve
 * @param preferred packages to prefer when resolving
 * @param packages is a pointer to a list of packages which will be
 *        searched first for any dependency packages needed to complete the
 *        resolve, and to which will be added any [pkg] and all of its
 *        dependencies not already on the list
 * @param remove is the set of packages which will be removed in this
 *        transaction
 * @param data returns the dependency which could not be satisfied in the
 *        event of an error
 * @return 0 on success, with [pkg] and all of its dependencies not already on
 *         the [*packages] list added to that list, or -1 on failure due to an
 *         unresolvable dependency, in which case the [*packages] list will be
 *         unmodified by this function
 */
int _alpm_resolvedeps(alpm_handle_t *handle, alpm_list_t *localpkgs,
		alpm_pkg_t *pkg, alpm_list_t *preferred, alpm_list_t **packages,
		alpm_list_t *rem, alpm_list_t **data)
{
	int ret = 0;
	alpm_list_t *j;
	alpm_list_t *targ;
	alpm_list_t *deps = NULL;
	alpm_list_t *packages_copy;

	if(alpm_pkg_find(*packages, pkg->name) != NULL) {
		return 0;
	}

	/* Create a copy of the packages list, so that it can be restored
	   on error */
	packages_copy = alpm_list_copy(*packages);
	/* [pkg] has not already been resolved into the packages list, so put it
	   on that list */
	*packages = alpm_list_add(*packages, pkg);

	_alpm_log(handle, ALPM_LOG_DEBUG, "started resolving dependencies\n");
	targ = alpm_list_add(NULL, pkg);
	deps = alpm_checkdeps(handle, localpkgs, rem, targ, 0);
	alpm_list_free(targ);
	targ = NULL;

	for(j = deps; j; j = j->next) {
		alpm_depmissing_t *miss = j->data;
		alpm_depend_t *missdep = miss->depend;
		/* check if one of the packages in the [*packages] list already satisfies
		 * this dependency */
		if(find_dep_satisfier(*packages, missdep)) {
			alpm_depmissing_free(miss);
			continue;
		}
		/* check if one of the packages in the [preferred] list already satisfies
		 * this dependency */
		alpm_pkg_t *spkg = find_dep_satisfier(preferred, missdep);
		if(!spkg) {
			/* find a satisfier package in the given repositories */
			spkg = resolvedep(handle, missdep, handle->dbs_sync, *packages, 0);
		}
		if(spkg && _alpm_resolvedeps(handle, localpkgs, spkg, preferred, packages, rem, data) == 0) {
			_alpm_log(handle, ALPM_LOG_DEBUG,
					"pulling dependency %s (needed by %s)\n",
					spkg->name, pkg->name);
			alpm_depmissing_free(miss);
		} else if(resolvedep(handle, missdep, (targ = alpm_list_add(NULL, handle->db_local)), rem, 0)) {
			alpm_depmissing_free(miss);
		} else {
			handle->pm_errno = ALPM_ERR_UNSATISFIED_DEPS;
			char *missdepstring = alpm_dep_compute_string(missdep);
			_alpm_log(handle, ALPM_LOG_WARNING,
					_("cannot resolve \"%s\", a dependency of \"%s\"\n"),
					missdepstring, pkg->name);
			free(missdepstring);
			if(data) {
				*data = alpm_list_add(*data, miss);
			}
			ret = -1;
		}
		alpm_list_free(targ);
		targ = NULL;
	}
	alpm_list_free(deps);

	if(ret != 0) {
		alpm_list_free(*packages);
		*packages = packages_copy;
	} else {
		alpm_list_free(packages_copy);
	}
	_alpm_log(handle, ALPM_LOG_DEBUG, "finished resolving dependencies\n");
	return ret;
}

char SYMEXPORT *alpm_dep_compute_string(const alpm_depend_t *dep)
{
	const char *name, *opr, *ver, *desc_delim, *desc;
	char *str;
	size_t len;

	ASSERT(dep != NULL, return NULL);

	if(dep->name) {
		name = dep->name;
	} else {
		name = "";
	}

	switch(dep->mod) {
		case ALPM_DEP_MOD_ANY:
			opr = "";
			break;
		case ALPM_DEP_MOD_GE:
			opr = ">=";
			break;
		case ALPM_DEP_MOD_LE:
			opr = "<=";
			break;
		case ALPM_DEP_MOD_EQ:
			opr = "=";
			break;
		case ALPM_DEP_MOD_LT:
			opr = "<";
			break;
		case ALPM_DEP_MOD_GT:
			opr = ">";
			break;
		default:
			opr = "";
			break;
	}

	if(dep->mod != ALPM_DEP_MOD_ANY && dep->version) {
		ver = dep->version;
	} else {
		ver = "";
	}

	if(dep->desc) {
		desc_delim = ": ";
		desc = dep->desc;
	} else {
		desc_delim = "";
		desc = "";
	}

	/* we can always compute len and print the string like this because opr
	 * and ver will be empty when ALPM_DEP_MOD_ANY is the depend type. the
	 * reassignments above also ensure we do not do a strlen(NULL). */
	len = strlen(name) + strlen(opr) + strlen(ver)
		+ strlen(desc_delim) + strlen(desc) + 1;
	MALLOC(str, len, return NULL);
	snprintf(str, len, "%s%s%s%s%s", name, opr, ver, desc_delim, desc);

	return str;
}
