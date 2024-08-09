#include <android/keycodes.h>
#include <linux/input-event-codes.h>
#include <xkbcommon/xkbcommon.h>

#include "backend/termuxgui.h"

static void
send_pointer_position(struct wlr_tgui_output *output, double x, double y, uint32_t time_ms) {
    struct wlr_pointer_motion_absolute_event ev = {
        .pointer = &output->backend->pointer,
        .time_msec = time_ms,
        .x = x,
        .y = y,
    };
    wl_signal_emit_mutable(&output->backend->pointer.events.motion_absolute, &ev);
    wl_signal_emit_mutable(&output->backend->pointer.events.frame, &output->backend->pointer);
}

static void send_pointer_button(struct wlr_tgui_output *output,
                                uint32_t button,
                                enum wlr_button_state state,
                                uint32_t time_ms) {
    struct wlr_pointer_button_event ev = {
        .pointer = &output->backend->pointer,
        .time_msec = time_ms,
        .button = button,
        .state = state,
    };
    wl_signal_emit_mutable(&output->backend->pointer.events.button, &ev);
    wl_signal_emit_mutable(&output->backend->pointer.events.frame, &output->backend->pointer);
}

static void send_pointer_axis(struct wlr_tgui_output *output, int32_t delta, uint64_t time_ms) {
    struct wlr_pointer_axis_event ev = {
        .pointer = &output->backend->pointer,
        .time_msec = time_ms,
        .source = WLR_AXIS_SOURCE_WHEEL,
        .orientation = WLR_AXIS_ORIENTATION_VERTICAL,
        .delta = delta * 15,
        .delta_discrete = delta * WLR_POINTER_AXIS_DISCRETE_STEP,
    };
    wl_signal_emit_mutable(&output->backend->pointer.events.axis, &ev);
    wl_signal_emit_mutable(&output->backend->pointer.events.frame, &output->backend->pointer);
}

static void move_cursor(struct wlr_tgui_output *output, double dx, double dy, uint32_t time_ms) {
    output->cursor_x -= dx;
    output->cursor_y -= dy;

    if (output->cursor_x < 0)
        output->cursor_x = 0;
    if (output->cursor_x > 1)
        output->cursor_x = 1;

    if (output->cursor_y < 0)
        output->cursor_y = 0;
    if (output->cursor_y > 1)
        output->cursor_y = 1;

    send_pointer_position(output, output->cursor_x, output->cursor_y, time_ms);
}

void handle_touch_event(tgui_event *e, struct wlr_tgui_output *output, uint64_t time_ms) {
    switch (e->touch.action) {
    case TGUI_TOUCH_DOWN: {
        tgui_touch_pointer *p = &e->touch.pointers[e->touch.index][0];
        memset(&output->touch_pointer, 0, sizeof(output->touch_pointer));
        output->touch_pointer.id = p->id;
        output->touch_pointer.max = 0;
        output->touch_pointer.x = (double) p->x / output->wlr_output.width;
        output->touch_pointer.y = (double) p->y / output->wlr_output.height;
        output->touch_pointer.time_ms = time_ms;
        break;
    }
    case TGUI_TOUCH_UP:
    case TGUI_TOUCH_POINTER_UP: {
        tgui_touch_pointer *p = &e->touch.pointers[e->touch.index][0];
        if (p->id == output->touch_pointer.id) {
            if (time_ms - output->touch_pointer.time_ms < 200 &&
                output->touch_pointer.down == false && output->touch_pointer.moved == false) {
                if (output->touch_pointer.max > 1) {
                    send_pointer_button(output, BTN_RIGHT, WLR_BUTTON_PRESSED, time_ms++);
                    send_pointer_button(output, BTN_RIGHT, WLR_BUTTON_RELEASED, time_ms);
                } else {
                    send_pointer_button(output, BTN_LEFT, WLR_BUTTON_PRESSED, time_ms++);
                    output->touch_pointer.down = true;
                }
            }
            if (output->touch_pointer.down) {
                send_pointer_button(output, BTN_LEFT, WLR_BUTTON_RELEASED, time_ms);
                output->touch_pointer.down = false;
            }
        }
        break;
    }
    case TGUI_TOUCH_MOVE: {
        for (uint32_t i = 0u; i < e->touch.num_pointers; i++) {
            tgui_touch_pointer *p = &e->touch.pointers[0][i];
            if (p->id != output->touch_pointer.id) {
                break;
            }
            double x = (double) p->x / output->wlr_output.width;
            double y = (double) p->y / output->wlr_output.height;
            double px = (double) 1 / output->wlr_output.width;
            double py = (double) 1 / output->wlr_output.height;
            double dx = output->touch_pointer.x - x;
            double dy = output->touch_pointer.y - y;
            if (dx >= px || dx <= -px || dy >= py || dy <= -py) {
                output->touch_pointer.x -= dx;
                output->touch_pointer.y -= dy;
                output->touch_pointer.moved = true;
            }
            if (output->touch_pointer.moved == true && e->touch.num_pointers == 2) {
                static double s;
                s += dy;
                if (s > (double) 150 / output->wlr_output.height) {
                    send_pointer_axis(output, 1, time_ms);
                    s = 0;
                } else if (s < (double) -150 / output->wlr_output.height) {
                    send_pointer_axis(output, -1, time_ms);
                    s = 0;
                }
            } else if (output->touch_pointer.moved == false &&
                       output->touch_pointer.down == false &&
                       time_ms - output->touch_pointer.time_ms > 200) {
                send_pointer_button(output, BTN_LEFT, WLR_BUTTON_PRESSED, time_ms);
                output->touch_pointer.down = true;
            } else {
                move_cursor(output, dx, dy, time_ms);
            }
        }
        if (e->touch.num_pointers > (uint32_t) output->touch_pointer.max) {
            output->touch_pointer.max = e->touch.num_pointers;
        }
        break;
    }
    default: {
        break;
    }
    }
}

static const struct {
    uint32_t android, linux, wlr_mod;
} keymap[] = {
    { AKEYCODE_0, KEY_0 },
    { AKEYCODE_1, KEY_1 },
    { AKEYCODE_2, KEY_2 },
    { AKEYCODE_3, KEY_3 },
    { AKEYCODE_4, KEY_4 },
    { AKEYCODE_5, KEY_5 },
    { AKEYCODE_6, KEY_6 },
    { AKEYCODE_7, KEY_7 },
    { AKEYCODE_8, KEY_8 },
    { AKEYCODE_9, KEY_9 },
    { AKEYCODE_A, KEY_A },
    { AKEYCODE_B, KEY_B },
    { AKEYCODE_C, KEY_C },
    { AKEYCODE_D, KEY_D },
    { AKEYCODE_E, KEY_E },
    { AKEYCODE_F, KEY_F },
    { AKEYCODE_G, KEY_G },
    { AKEYCODE_H, KEY_H },
    { AKEYCODE_I, KEY_I },
    { AKEYCODE_J, KEY_J },
    { AKEYCODE_K, KEY_K },
    { AKEYCODE_L, KEY_L },
    { AKEYCODE_M, KEY_M },
    { AKEYCODE_N, KEY_N },
    { AKEYCODE_O, KEY_O },
    { AKEYCODE_P, KEY_P },
    { AKEYCODE_Q, KEY_Q },
    { AKEYCODE_R, KEY_R },
    { AKEYCODE_S, KEY_S },
    { AKEYCODE_T, KEY_T },
    { AKEYCODE_U, KEY_U },
    { AKEYCODE_V, KEY_V },
    { AKEYCODE_W, KEY_W },
    { AKEYCODE_X, KEY_X },
    { AKEYCODE_Y, KEY_Y },
    { AKEYCODE_Z, KEY_Z },
    { AKEYCODE_ENTER, KEY_ENTER },
    { AKEYCODE_SPACE, KEY_SPACE },
    { AKEYCODE_DEL, KEY_BACKSPACE },
    { AKEYCODE_SHIFT_LEFT, KEY_LEFTSHIFT },
    { AKEYCODE_COMMA, KEY_COMMA },
    { AKEYCODE_PERIOD, KEY_DOT },
    { AKEYCODE_MINUS, KEY_MINUS },
    { AKEYCODE_AT, KEY_2, WLR_MODIFIER_SHIFT },
    { AKEYCODE_STAR, KEY_8, WLR_MODIFIER_SHIFT },
    { AKEYCODE_POUND, KEY_3, WLR_MODIFIER_SHIFT },
    { AKEYCODE_SEMICOLON, KEY_SEMICOLON },
    { AKEYCODE_APOSTROPHE, KEY_APOSTROPHE },
    { AKEYCODE_SLASH, KEY_SLASH },
    { AKEYCODE_EQUALS, KEY_EQUAL },
    { AKEYCODE_PLUS, KEY_EQUAL, WLR_MODIFIER_SHIFT },
    { AKEYCODE_GRAVE, KEY_GRAVE },
    { AKEYCODE_BACKSLASH, KEY_BACKSLASH },
    { AKEYCODE_LEFT_BRACKET, KEY_LEFTBRACE },
    { AKEYCODE_RIGHT_BRACKET, KEY_RIGHTBRACE },
};

static bool get_keycode_and_modifier(uint32_t code, uint32_t *keycode, uint32_t *out_mod) {
    for (size_t i = 0; i < sizeof(keymap) / sizeof(*keymap); i++) {
        if (code == keymap[i].android) {
            *keycode = keymap[i].linux;
            *out_mod = keymap[i].wlr_mod;
            return true;
        }
    }

    return false;
}

void handle_keyboard_event(tgui_event *e, struct wlr_tgui_output *output, uint64_t time_ms) {
    uint32_t keycode, modifiers;

    if (!get_keycode_and_modifier(e->key.code, &keycode, &modifiers)) {
        wlr_log(WLR_ERROR, "Unhandled keycode %d %c", e->key.code, e->key.codePoint);
        return;
    }

    if (e->key.mod & (TGUI_MOD_LSHIFT | TGUI_MOD_RSHIFT))
        modifiers |= WLR_MODIFIER_SHIFT;
    if (e->key.mod & (TGUI_MOD_LCTRL | TGUI_MOD_RCTRL))
        modifiers |= WLR_MODIFIER_CTRL;
    if (e->key.mod & TGUI_MOD_ALT)
        modifiers |= WLR_MODIFIER_ALT;

    xkb_layout_index_t group =
        xkb_state_key_get_layout(output->backend->keyboard.xkb_state, keycode + 8);
    wlr_keyboard_notify_modifiers(&output->backend->keyboard, modifiers, 0, 0, group);

    struct wlr_keyboard_key_event key = {
        .time_msec = time_ms,
        .keycode = keycode,
        .state = e->key.down ? WL_KEYBOARD_KEY_STATE_PRESSED : WL_KEYBOARD_KEY_STATE_RELEASED,
        .update_state = true,
    };
    wlr_keyboard_notify_key(&output->backend->keyboard, &key);
}
