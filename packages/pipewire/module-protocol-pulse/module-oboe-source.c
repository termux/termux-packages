/* PipeWire */
/* SPDX-FileCopyrightText: Copyright © 2021 Wim Taymans <wim.taymans@gmail.com> */
/* SPDX-FileCopyrightText: Copyright © 2021 Sanchayan Maity <sanchayan@asymptotic.io> */
/* SPDX-License-Identifier: MIT */

#include <spa/utils/hook.h>
#include <pipewire/pipewire.h>

#include "../defs.h"
#include "../module.h"

/** \page page_pulse_module_oboe_source Oboe Source
 *
 * ## Module Name
 *
 * `module-oboe-source`
 *
 * ## Module Options
 *
 * @pulse_module_options@
 *
 * ## See Also
 *
 * \ref page_module_oboe_source "libpipewire-module-oboe-source"
 */

static const char *const pulse_module_options =
	"node_latency=<latency as fraction> "
	"node_name=<name of the nodes> "
	"node_description=<description of the nodes> "
	"audio_format=<format> "
	"audio_rate=<sample rate> "
	"audio_channels=<number of channels> "
	"audio_position=<channel map> "
	"stream_read_timeout=<number of nanosecs> "
	"stream_props=<properties> "
	;

#define NAME "oboe-source"

PW_LOG_TOPIC_STATIC(mod_topic, "mod." NAME);
#define PW_LOG_TOPIC_DEFAULT mod_topic

struct module_oboe_source_data {
	struct module *module;

	struct spa_hook mod_listener;
	struct pw_impl_module *mod;

	struct pw_properties *stream_props;
	struct pw_properties *oboe_props;
};

static void module_destroy(void *data)
{
	struct module_oboe_source_data *d = data;
	spa_hook_remove(&d->mod_listener);
	d->mod = NULL;
	module_schedule_unload(d->module);
}

static const struct pw_impl_module_events module_events = {
	PW_VERSION_IMPL_MODULE_EVENTS,
	.destroy = module_destroy
};

static int module_oboe_source_load(struct module *module)
{
	struct module_oboe_source_data *data = module->user_data;
	FILE *f;
	char *args;
	size_t size;

	if ((f = open_memstream(&args, &size)) == NULL)
		return -errno;

	fprintf(f, "{");
	pw_properties_serialize_dict(f, &data->oboe_props->dict, 0);
	fprintf(f, " \"stream.props\": {");
	pw_properties_serialize_dict(f, &data->stream_props->dict, 0);
	fprintf(f, " } }");
	fclose(f);

	data->mod = pw_context_load_module(module->impl->context,
			"libpipewire-module-oboe-source",
			args, NULL);

	free(args);

	if (data->mod == NULL)
		return -errno;

	pw_impl_module_add_listener(data->mod,
			&data->mod_listener,
			&module_events, data);

	return 0;
}

static int module_oboe_source_unload(struct module *module)
{
	struct module_oboe_source_data *d = module->user_data;

	if (d->mod) {
		spa_hook_remove(&d->mod_listener);
		pw_impl_module_destroy(d->mod);
		d->mod = NULL;
	}

	pw_properties_free(d->oboe_props);
	pw_properties_free(d->stream_props);

	return 0;
}

static const char* const valid_args[] = {
	"node_latency",
	"node_name",
	"node_description",
	"audio_format",
	"audio_rate",
	"audio_channels",
	"audio_position",
	"stream_read_timeout",
	"stream_props",
	NULL
};

static const struct spa_dict_item module_oboe_source_info[] = {
	{ PW_KEY_MODULE_AUTHOR, "Sanchayan Maity <sanchayan@asymptotic.io>" },
	{ PW_KEY_MODULE_DESCRIPTION, "oboe source" },
	{ PW_KEY_MODULE_USAGE, pulse_module_options },
	{ PW_KEY_MODULE_VERSION, PACKAGE_VERSION },
};

static int module_oboe_source_prepare(struct module * const module)
{
	struct module_oboe_source_data * const d = module->user_data;
	struct pw_properties * const props = module->props;
	struct pw_properties *stream_props = NULL, *oboe_props = NULL;
	const char *str;
	int res;

	PW_LOG_TOPIC_INIT(mod_topic);

	stream_props = pw_properties_new(NULL, NULL);
	oboe_props = pw_properties_new(NULL, NULL);
	if (!stream_props || !oboe_props) {
		res = -errno;
		goto out;
	}

	if ((str = pw_properties_get(props, "node_latency")) != NULL) {
		pw_properties_set(oboe_props, "node.latency", str);
		pw_properties_set(props, "node_latency", NULL);
	}
	if ((str = pw_properties_get(props, "node_name")) != NULL) {
		pw_properties_set(oboe_props, "node.name", str);
		pw_properties_set(props, "node_name", NULL);
	}
	if ((str = pw_properties_get(props, "node_description")) != NULL) {
		pw_properties_set(oboe_props, "node.description", str);
		pw_properties_set(props, "node_description", NULL);
	}
	if ((str = pw_properties_get(props, "audio_format")) != NULL) {
		pw_properties_set(oboe_props, "audio.format", str);
		pw_properties_set(props, "audio_format", NULL);
	}
	if ((str = pw_properties_get(props, "audio_rate")) != NULL) {
		pw_properties_set(oboe_props, "audio.rate", str);
		pw_properties_set(props, "audio_rate", NULL);
	}
	if ((str = pw_properties_get(props, "audio_channels")) != NULL) {
		pw_properties_set(oboe_props, "audio.channels", str);
		pw_properties_set(props, "audio_channels", NULL);
	}
	if ((str = pw_properties_get(props, "audio_position")) != NULL) {
		pw_properties_set(oboe_props, "audio.position", str);
		pw_properties_set(props, "audio_position", NULL);
	}
	if ((str = pw_properties_get(props, "stream_write_timeout")) != NULL) {
		pw_properties_set(oboe_props, "stream.write.timeout", str);
		pw_properties_set(props, "stream_write_timeout", NULL);
	}
	if ((str = pw_properties_get(props, "stream_properties")) != NULL) {
		module_args_add_props(stream_props, str);
		pw_properties_set(props, "stream_properties", NULL);
	}

	d->module = module;
	d->stream_props = stream_props;
	d->oboe_props = oboe_props;

	return 0;
out:
	pw_properties_free(stream_props);
	pw_properties_free(oboe_props);

	return res;
}

DEFINE_MODULE_INFO(module_oboe_source) = {
	.name = "module-oboe-source",
	.valid_args = valid_args,
	.prepare = module_oboe_source_prepare,
	.load = module_oboe_source_load,
	.unload = module_oboe_source_unload,
	.properties = &SPA_DICT_INIT_ARRAY(module_oboe_source_info),
	.data_size = sizeof(struct module_oboe_source_data),
};
