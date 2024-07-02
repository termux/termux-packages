/*
 * This an unstable interface of wlroots. No guarantees are made regarding the
 * future consistency of this API.
 */
#ifndef WLR_USE_UNSTABLE
#error "Add -DWLR_USE_UNSTABLE to enable unstable wlroots features"
#endif

#ifndef WLR_BACKEND_TERMUXGUI_H
#define WLR_BACKEND_TERMUXGUI_H

#include <wlr/backend.h>
#include <wlr/types/wlr_output.h>

/**
 * Creates a Termux:GUI backend, and connection to the Termux:GUI plugin.
 * A Termux:GUI backend has no outputs or inputs by default.
 */
struct wlr_backend *wlr_tgui_backend_create(struct wl_display *display);
/**
 * Create a new Termux:GUI output.
 *
 * Will use Termux:GUI plugin to create Activity and SurfaceView, the buffers presented
 * on the output is displayed to the SurfaceView.
 */
struct wlr_output *wlr_tgui_output_create(struct wlr_backend *backend);

bool wlr_backend_is_tgui(struct wlr_backend *backend);
bool wlr_output_is_tgui(struct wlr_output *output);

#endif
