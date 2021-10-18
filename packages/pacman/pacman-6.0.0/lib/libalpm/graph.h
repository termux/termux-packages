/*
 *  graph.h - helpful graph structure and setup/teardown methods
 *
 *  Copyright (c) 2007-2021 Pacman Development Team <pacman-dev@archlinux.org>
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
#ifndef ALPM_GRAPH_H
#define ALPM_GRAPH_H

#include <sys/types.h> /* off_t */

#include "alpm_list.h"

enum __alpm_graph_vertex_state {
	ALPM_GRAPH_STATE_UNPROCESSED,
	ALPM_GRAPH_STATE_PROCESSING,
	ALPM_GRAPH_STATE_PROCESSED
};

typedef struct __alpm_graph_t {
	void *data;
	struct __alpm_graph_t *parent; /* where did we come from? */
	alpm_list_t *children;
	alpm_list_t *iterator; /* used for DFS without recursion */
	off_t weight; /* weight of the node */
	enum __alpm_graph_vertex_state state;
} alpm_graph_t;

alpm_graph_t *_alpm_graph_new(void);
void _alpm_graph_free(void *data);

#endif /* ALPM_GRAPH_H */
