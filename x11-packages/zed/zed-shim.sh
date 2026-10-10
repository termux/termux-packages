#!/usr/bin/env sh

# The zed CLI looks for ../libexec/zed-editor.
# Allow emulated (software) GPUs by default, as there is
# often no hardware Vulkan driver on Android.
ZED_ALLOW_EMULATED_GPU="${ZED_ALLOW_EMULATED_GPU:-1}" exec "@TERMUX_PREFIX@/libexec/zed/zed-editor" "$@"
