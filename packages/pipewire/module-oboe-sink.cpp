/* PipeWire */
/* SPDX-FileCopyrightText: Copyright © 2021 Wim Taymans */
/* SPDX-License-Identifier: MIT */

#include <oboe/Oboe.h>

extern "C" {

#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <limits.h>
#include <math.h>

#include "config.h"

#include <spa/utils/result.h>
#include <spa/utils/string.h>
#include <spa/utils/json.h>
#include <spa/utils/ringbuffer.h>
#include <spa/debug/types.h>
#include <spa/pod/builder.h>
#include <spa/param/audio/format-utils.h>
#include <spa/param/audio/raw.h>

#include <pipewire/impl.h>
#include <pipewire/i18n.h>

#define NANOS_PER_MILLISECOND 1000000L

/** \page page_module_oboe_sink Oboe Sink
 *
 * ## Module Name
 *
 * `libpipewire-module-oboe-sink`
 *
 * ## Module Options
 *
 * - `node.name`: a unique name for the stream
 * - `node.description`: a human readable name for the stream
 * - `stream.props = {}`: properties to be passed to the stream
 *
 * ## General options
 *
 * Options with well-known behavior.
 *
 * - \ref PW_KEY_REMOTE_NAME
 * - \ref PW_KEY_AUDIO_FORMAT
 * - \ref PW_KEY_AUDIO_RATE
 * - \ref PW_KEY_AUDIO_CHANNELS
 * - \ref SPA_KEY_AUDIO_POSITION
 * - \ref PW_KEY_MEDIA_NAME
 * - \ref PW_KEY_NODE_LATENCY
 * - \ref PW_KEY_NODE_NAME
 * - \ref PW_KEY_NODE_DESCRIPTION
 * - \ref PW_KEY_NODE_GROUP
 * - \ref PW_KEY_NODE_VIRTUAL
 * - \ref PW_KEY_MEDIA_CLASS
 *
 * ## Configuration
 *
 *\code{.unparsed}
 * context.modules = [
 * {   name = libpipewire-module-oboe-sink
 *     args = {
 *         node.name = "oboe_sink"
 *         node.description = "My Oboe Sink"
 *         stream.props = {
 *             audio.position = [ FL FR ]
 *         }
 *     }
 * }
 * ]
 *\endcode
 */

#define NAME "oboe-sink"

PW_LOG_TOPIC_STATIC(mod_topic, "mod." NAME);
#define PW_LOG_TOPIC_DEFAULT mod_topic

#define DEFAULT_FORMAT "S16LE"
#define DEFAULT_RATE 48000
#define DEFAULT_CHANNELS 2
#define DEFAULT_POSITION "[ FL FR ]"
#define DEFAULT_STREAM_WRITE_TIMEOUT 0

#define MODULE_USAGE	"( node.latency=<latency as fraction> ) "				\
			"( node.name=<name of the nodes> ) "					\
			"( node.description=<description of the nodes> ) "			\
			"( audio.format=<format, S16LE or F32LE, default:" DEFAULT_FORMAT "> ) "			\
			"( audio.rate=<sample rate, default: " SPA_STRINGIFY(DEFAULT_RATE) "> ) "			\
			"( audio.channels=<number of channels, default:" SPA_STRINGIFY(DEFAULT_CHANNELS) "> ) "	\
			"( audio.position=<channel map, default:" DEFAULT_POSITION "> ) "		\
			"( stream.write.timeout=<timeout for wrtiing into stream in nanosecs, default:" SPA_STRINGIFY(DEFAULT_STREAM_WRITE_TIMEOUT) "> ) "	\
			"( stream.props=<properties> ) "


static const struct spa_dict_item module_props[] = {
	{ PW_KEY_MODULE_AUTHOR, "Ronald Y" },
	{ PW_KEY_MODULE_DESCRIPTION, "Oboe (Andoird) audio sink" },
	{ PW_KEY_MODULE_USAGE, MODULE_USAGE },
	{ PW_KEY_MODULE_VERSION, PACKAGE_VERSION },
};

struct impl {
	struct pw_context *context;

	struct pw_properties *props;

	struct pw_impl_module *module;

	struct spa_hook module_listener;

	struct pw_core *core;
	struct spa_hook core_proxy_listener;
	struct spa_hook core_listener;

	struct pw_properties *stream_props;
	struct pw_stream *stream;
	struct spa_hook stream_listener;
	struct spa_audio_info_raw info;
	uint32_t frame_size;
	int64_t stream_write_timeout;

	unsigned int do_disconnect:1;

    std::shared_ptr<oboe::AudioStream> oboe_stream;
};

static void stream_destroy(void *d)
{
	struct impl *impl = (struct impl *)d;
	spa_hook_remove(&impl->stream_listener);
	impl->stream = NULL;
}

static void stream_state_changed(void *d, enum pw_stream_state old,
		enum pw_stream_state state, const char *error)
{
	struct impl *impl = (struct impl *)d;
	switch (state) {
	case PW_STREAM_STATE_ERROR:
	case PW_STREAM_STATE_UNCONNECTED:
		pw_log_debug("destroy triggered by stream state changed, pw_stream_state = %d", state);
        impl->oboe_stream->close();
		pw_impl_module_schedule_destroy(impl->module);
		break;
	case PW_STREAM_STATE_PAUSED:
	case PW_STREAM_STATE_STREAMING:
		break;
	default:
		break;
	}
}

static int open_oboe_stream(struct impl *impl);

static void playback_stream_process(void *d)
{
	struct impl *impl = (struct impl *)d;
	struct pw_buffer *buf;
	struct spa_data *bd;
	void *data;
	uint32_t offs, size, i;
    oboe::Result returnCode;

	if ((buf = pw_stream_dequeue_buffer(impl->stream)) == NULL) {
		pw_log_debug("out of buffers: %m");
		return;
	}

	for (i = 0; i < buf->buffer->n_datas; i++) {
		bd = &buf->buffer->datas[i];

		offs = SPA_MIN(bd->chunk->offset, bd->maxsize);
		size = SPA_MIN(bd->maxsize - offs, bd->chunk->size);

        spa_zero(data);
	    data = SPA_PTROFF(bd->data, offs, void);
        
		// TODO: investigate timeout
        if ((returnCode = impl->oboe_stream->write(data, size / impl->frame_size, impl->stream_write_timeout)) != oboe::Result::OK)
            pw_log_error("Oboe stream write() error: %s", oboe::convertToText(returnCode));
		if (returnCode == oboe::Result::ErrorDisconnected)
			open_oboe_stream(impl);
	}
	pw_log_info("got buffer of size %d (= %d frames) and data %p", size, size / impl->frame_size, data);

	pw_stream_queue_buffer(impl->stream, buf);
}

static const struct pw_stream_events playback_stream_events = {
	PW_VERSION_STREAM_EVENTS,
	.destroy = stream_destroy,
	.state_changed = stream_state_changed,
	.process = playback_stream_process
};


// static void core_destroy(void *d);

// static void error_callback(std::shared_ptr<oboe::AudioStream> stream, void *impl, oboe::Result error) {
//     pw_log_debug("Oboe error: %d", error);
//     core_destroy(impl);
// }

#define CHK(stmt) { \
    oboe::Result res = stmt; \
    if (res != oboe::Result::OK) { \
        pw_log_error("Oboe error %s at %s:%d\n", oboe::convertToText(res), __FILE__, __LINE__); \
        goto fail; \
    } \
}

static int open_oboe_stream(struct impl *impl)
{
    oboe::AudioFormat format;
	oboe::AudioStreamBuilder builder;
    switch (impl->info.format) {
        case SPA_AUDIO_FORMAT_S16_LE: format = oboe::AudioFormat::I16; break;
        case SPA_AUDIO_FORMAT_F32_LE: format = oboe::AudioFormat::Float; break;
        default: 
            pw_log_error( "audio format not supported. ");
            goto fail;
    }

	CHK(builder.setDirection(oboe::Direction::Output)
				->setSharingMode(oboe::SharingMode::Shared)
                ->setChannelCount(impl->info.channels)
                ->setSampleRate(impl->info.rate)
				->setSampleRateConversionQuality(oboe::SampleRateConversionQuality::Medium)
                ->setFormat(format)
				// TODO: error callback
				// ->setErrorCallback(error_callback)
                ->openStream(impl->oboe_stream));

    impl->info.rate = impl->oboe_stream->getSampleRate();

	CHK(impl->oboe_stream->requestStart());
	CHK(impl->oboe_stream->waitForStateChange(oboe::StreamState::Starting, NULL, 1000 * NANOS_PER_MILLISECOND));
    return 0;

fail:
    return -1;
}


static int create_stream(struct impl *impl)
{
	int res;
	uint32_t n_params;
	const struct spa_pod *params[1];
	uint8_t buffer[1024];
	struct spa_pod_builder b;

    open_oboe_stream(impl);
	impl->stream = pw_stream_new(impl->core, "oboe sink", impl->stream_props);
	impl->stream_props = NULL;

	if (impl->stream == NULL)
		return -errno;

	pw_stream_add_listener(impl->stream,
			&impl->stream_listener,
			&playback_stream_events, impl);

	n_params = 0;
	spa_pod_builder_init(&b, buffer, sizeof(buffer));
	params[n_params++] = spa_format_audio_raw_build(&b,
			SPA_PARAM_EnumFormat, &impl->info);

	if ((res = pw_stream_connect(impl->stream,
			PW_DIRECTION_INPUT,
			PW_ID_ANY,
			static_cast<pw_stream_flags>(PW_STREAM_FLAG_AUTOCONNECT |
			PW_STREAM_FLAG_MAP_BUFFERS |
			PW_STREAM_FLAG_RT_PROCESS),
			params, n_params)) < 0)
		return res;

	return 0;
}

static void core_error(void *data, uint32_t id, int seq, int res, const char *message)
{
	struct impl *impl = (struct impl *)data;

	pw_log_error("error id:%u seq:%d res:%d (%s): %s",
			id, seq, res, spa_strerror(res), message);

	if (id == PW_ID_CORE && res == -EPIPE) {
        impl->oboe_stream->close();
		pw_impl_module_schedule_destroy(impl->module);
	}
}

static const struct pw_core_events core_events = {
	PW_VERSION_CORE_EVENTS,
	.error = core_error,
};

static void core_destroy(void *d)
{
	struct impl *impl = (struct impl *)d;
	impl->oboe_stream->close();
	spa_hook_remove(&impl->core_listener);
	impl->core = NULL;
	pw_impl_module_schedule_destroy(impl->module);
}

static const struct pw_proxy_events core_proxy_events = {
	.destroy = core_destroy,
};

static void impl_destroy(struct impl *impl)
{
	if (impl->stream)
		pw_stream_destroy(impl->stream);
	if (impl->core && impl->do_disconnect)
		pw_core_disconnect(impl->core);

	pw_properties_free(impl->stream_props);
	pw_properties_free(impl->props);

	free(impl);
}

static void module_destroy(void *data)
{
	struct impl *impl = (struct impl *)data;
	spa_hook_remove(&impl->module_listener);
	impl_destroy(impl);
}

static const struct pw_impl_module_events module_events = {
	PW_VERSION_IMPL_MODULE_EVENTS,
	.destroy = module_destroy,
};

static inline uint32_t format_from_name(const char *name, size_t len)
{
	int i;
	for (i = 0; spa_type_audio_format[i].name; i++) {
		if (strncmp(name, spa_debug_type_short_name(spa_type_audio_format[i].name), len) == 0)
			return spa_type_audio_format[i].type;
	}
	return SPA_AUDIO_FORMAT_UNKNOWN;
}

static uint32_t channel_from_name(const char *name)
{
	int i;
	for (i = 0; spa_type_audio_channel[i].name; i++) {
		if (spa_streq(name, spa_debug_type_short_name(spa_type_audio_channel[i].name)))
			return spa_type_audio_channel[i].type;
	}
	return SPA_AUDIO_CHANNEL_UNKNOWN;
}

static void parse_position(struct spa_audio_info_raw *info, const char *val, size_t len)
{
	struct spa_json it[2];
	char v[256];

	spa_json_init(&it[0], val, len);
	if (spa_json_enter_array(&it[0], &it[1]) <= 0)
			spa_json_init(&it[1], val, len);

	info->channels = 0;
	while (spa_json_get_string(&it[1], v, sizeof(v)) > 0 &&
	    info->channels < SPA_AUDIO_MAX_CHANNELS) {
		info->position[info->channels++] = channel_from_name(v);
	}
}

static void parse_audio_info(const struct pw_properties *props, struct spa_audio_info_raw *info)
{
	const char *str;

	spa_zero(*info);
	if ((str = pw_properties_get(props, PW_KEY_AUDIO_FORMAT)) == NULL)
		str = DEFAULT_FORMAT;
	info->format = static_cast<spa_audio_format>(format_from_name(str, strlen(str)));
	switch (info->format) {
		case SPA_AUDIO_FORMAT_S16_LE: 
		case SPA_AUDIO_FORMAT_F32_LE: 
			break;
		default:
            pw_log_error( "audio format not supported. fallback to SPA_AUDIO_FORMAT_S16_LE. ");
			info->format = SPA_AUDIO_FORMAT_S16_LE;
	}

	info->rate = pw_properties_get_uint32(props, PW_KEY_AUDIO_RATE, info->rate);
	if (info->rate == 0)
		info->rate = DEFAULT_RATE;

	info->channels = pw_properties_get_uint32(props, PW_KEY_AUDIO_CHANNELS, info->channels);
	info->channels = SPA_MIN(info->channels, SPA_AUDIO_MAX_CHANNELS);
	if ((str = pw_properties_get(props, SPA_KEY_AUDIO_POSITION)) != NULL)
		parse_position(info, str, strlen(str));
	if (info->channels == 0)
		parse_position(info, DEFAULT_POSITION, strlen(DEFAULT_POSITION));
}

static int calc_frame_size(const struct spa_audio_info_raw *info)
{
	int res = info->channels;
	switch (info->format) {
	case SPA_AUDIO_FORMAT_U8:
	case SPA_AUDIO_FORMAT_S8:
	case SPA_AUDIO_FORMAT_ALAW:
	case SPA_AUDIO_FORMAT_ULAW:
		return res;
	case SPA_AUDIO_FORMAT_S16:
	case SPA_AUDIO_FORMAT_S16_OE:
	case SPA_AUDIO_FORMAT_U16:
		return res * 2;
	case SPA_AUDIO_FORMAT_S24:
	case SPA_AUDIO_FORMAT_S24_OE:
	case SPA_AUDIO_FORMAT_U24:
		return res * 3;
	case SPA_AUDIO_FORMAT_S24_32:
	case SPA_AUDIO_FORMAT_S24_32_OE:
	case SPA_AUDIO_FORMAT_S32:
	case SPA_AUDIO_FORMAT_S32_OE:
	case SPA_AUDIO_FORMAT_U32:
	case SPA_AUDIO_FORMAT_U32_OE:
	case SPA_AUDIO_FORMAT_F32:
	case SPA_AUDIO_FORMAT_F32_OE:
		return res * 4;
	case SPA_AUDIO_FORMAT_F64:
	case SPA_AUDIO_FORMAT_F64_OE:
		return res * 8;
	default:
		return 0;
	}
}

static void copy_props(struct impl *impl, struct pw_properties *props, const char *key)
{
	const char *str;
	if ((str = pw_properties_get(props, key)) != NULL) {
		if (pw_properties_get(impl->stream_props, key) == NULL)
			pw_properties_set(impl->stream_props, key, str);
	}
}

SPA_EXPORT
int pipewire__module_init(struct pw_impl_module *module, const char *args)
{
	struct pw_context *context = pw_impl_module_get_context(module);
	struct pw_properties *props = NULL;
	uint32_t id = pw_global_get_id(pw_impl_module_get_global(module));
	uint32_t pid = getpid();
	struct impl *impl;
	const char *str;
	int res;
	spa_dict temp_spa_dict;

	PW_LOG_TOPIC_INIT(mod_topic);

	impl = (struct impl *)calloc(1, sizeof(struct impl));
	if (impl == NULL)
		return -errno;

	pw_log_debug("module %p: new %s", impl, args);

	if (args == NULL)
		args = "";

	props = pw_properties_new_string(args);
	if (props == NULL) {
		res = -errno;
		pw_log_error( "can't create properties: %m");
		goto error;
	}
	impl->props = props;

	impl->stream_props = pw_properties_new(NULL, NULL);
	if (impl->stream_props == NULL) {
		res = -errno;
		pw_log_error( "can't create properties: %m");
		goto error;
	}

	impl->module = module;
	impl->context = context;

	if (pw_properties_get(props, PW_KEY_NODE_VIRTUAL) == NULL)
		pw_properties_set(props, PW_KEY_NODE_VIRTUAL, "true");

	if (pw_properties_get(props, PW_KEY_MEDIA_CLASS) == NULL)
		pw_properties_set(props, PW_KEY_MEDIA_CLASS, "Audio/Sink");

	if (pw_properties_get(props, PW_KEY_NODE_NAME) == NULL)
		pw_properties_setf(props, PW_KEY_NODE_NAME, "oboe-sink-%u-%u", pid, id);
	if (pw_properties_get(props, PW_KEY_NODE_DESCRIPTION) == NULL)
		pw_properties_set(props, PW_KEY_NODE_DESCRIPTION,
				pw_properties_get(props, PW_KEY_NODE_NAME));

	if ((str = pw_properties_get(props, "stream.props")) != NULL) {
		pw_properties_update_string(impl->stream_props, str, strlen(str));
		pw_log_debug( "stream.props set by args: %s", str);
	}

	copy_props(impl, props, PW_KEY_AUDIO_RATE);
	copy_props(impl, props, PW_KEY_AUDIO_CHANNELS);
	copy_props(impl, props, SPA_KEY_AUDIO_POSITION);
	copy_props(impl, props, PW_KEY_NODE_NAME);
	copy_props(impl, props, PW_KEY_NODE_DESCRIPTION);
	copy_props(impl, props, PW_KEY_NODE_GROUP);
	copy_props(impl, props, PW_KEY_NODE_LATENCY);
	copy_props(impl, props, PW_KEY_NODE_VIRTUAL);
	copy_props(impl, props, PW_KEY_MEDIA_CLASS);

	parse_audio_info(impl->stream_props, &impl->info);

	impl->frame_size = calc_frame_size(&impl->info);
	impl->stream_write_timeout = pw_properties_get_uint64(props, "stream.write.timeout", DEFAULT_STREAM_WRITE_TIMEOUT);
	pw_log_debug( "stream write timeout set to %d", impl->stream_write_timeout);
	if (impl->frame_size == 0) {
		res = -EINVAL;
		pw_log_error( "can't parse audio format");
		goto error;
	}

	impl->core = (struct pw_core *)pw_context_get_object(impl->context, PW_TYPE_INTERFACE_Core);
	if (impl->core == NULL) {
		str = pw_properties_get(props, PW_KEY_REMOTE_NAME);
		impl->core = pw_context_connect(impl->context,
				pw_properties_new(
					PW_KEY_REMOTE_NAME, str,
					NULL),
				0);
		impl->do_disconnect = true;
	}
	if (impl->core == NULL) {
		res = -errno;
		pw_log_error("can't connect: %m");
		goto error;
	}

	pw_proxy_add_listener((struct pw_proxy*)impl->core,
			&impl->core_proxy_listener,
			&core_proxy_events, impl);
	pw_core_add_listener(impl->core,
			&impl->core_listener,
			&core_events, impl);

	if ((res = create_stream(impl)) < 0)
		goto error;

	pw_impl_module_add_listener(module, &impl->module_listener, &module_events, impl);

	temp_spa_dict = (struct spa_dict) { 0, SPA_N_ELEMENTS(module_props), (module_props) };
	pw_impl_module_update_properties(module, &temp_spa_dict);

	return 0;

error:
	impl_destroy(impl);
	return res;
}


}
