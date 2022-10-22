# Default configuration file documentation

This document explains the default `rc.lua` file provided by Awesome.

 awesome_mode: api-level=4:screen=on
 If LuaRocks is installed, make sure that packages installed through it are
 found (e.g. lgi). If LuaRocks is not installed, do nothing.

    pcall(require, "luarocks.loader")
    

The Awesome API is distributed across many libraries (also called modules).

Here are the modules that we import:

<table class='widget_list' border=1>
  <tr style='font-weight: bold;'>
   <th align='center'>Library</th>
   <th align='center'>Description</th>
  </tr>
  <tr><td>`gears`</td><td>Utilities such as color parsing and objects</td></tr>
  <tr><td>`wibox`</td><td>Awesome own generic widget framework</td></tr>
  <tr><td>`awful`</td><td>Everything related to window managment</td></tr>
  <tr><td>`naughty`</td><td>Notifications</td></tr>
  <tr><td>`ruled`</td><td>Define declarative rules on various events</td></tr>
  <tr><td>`menubar`</td><td>XDG (application) menu implementation</td></tr>
  <tr><td>`beautiful`</td><td>Awesome theme module</td></tr>
</table>

 Standard awesome library

    local gears = require("gears")
    local awful = require("awful")
    require("`awful.autofocus`")

 Widget and layout library

    local wibox = require("wibox")

 Theme handling library

    local beautiful = require("beautiful")

 Notification library

    local naughty = require("naughty")

 Declarative object management

    local ruled = require("ruled")
    local menubar = require("menubar")
    local hotkeys_popup = require("`awful.hotkeys`_popup")

 Enable hotkeys help widget for VIM and other apps
 when client with a matching name is opened:

    require("`awful.hotkeys`_popup.keys")
    

## Error handling
 Check if awesome encountered an error during startup and fell back to
 another config (This code will only ever execute for the fallback config)

Awesome is a window managing framework. It allows its users great (ultimate?)
flexibility. However, it also allows the user to write invalid code. Here's a
non-exhaustive list of possible errors:

 * Syntax: There is an `awesome -k` option available in the command line to
   check the configuration file. Awesome cannot start with an invalid `rc.lua`
 * Invalid APIs and type errors: Lua is a dynamic language. It doesn't have much
   support for static/compile time checks. There is the `luacheck` utility to
   help find some categories of errors. Those errors will cause Awesome to
   "drop" the current call stack and start over. Note that if it cannot
   reach the end of the `rc.lua` without errors, it will fall back to the
   original file.
 * Invalid logic: It is possible to write fully valid code that will render
   Awesome unusable (like an infinite loop or blocking commands). In that case,
   the best way to debug this is either using `print()` or using `gdb`. For
   this, see the [Debugging tips Readme section](../documentation/01-readme.md.html)
 * Deprecated APIs: The Awesome API is not frozen for eternity. After a decade
   of development and recent changes to enforce consistency, it hasn't
   changed much. This doesn't mean it won't change in the future. Whenever
   possible, changes won't cause errors but will instead print a deprecation
   message in the Awesome logs. These logs are placed in various places
   depending on the distribution. By default, Awesome will print errors on
  `stderr` and `stdout`.



    `naughty.connect`_signal("request::display_error", function(message, startup)
        `naughty.notification` {
            urgency = "critical",
            title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
            message = message
        }
    end)
    

## Variable definitions
To create custom themes, the easiest way is to copy the `default` theme folder
from `/usr/share/awesome/themes/` into `~/.config/awesome` and modify it.

Awesome currently doesn't behave well without a theme containing all the "basic"
variables such as `bg_normal`. To get a list of all official variables, see
the [appearance guide](../documentation/06-appearance.md.html).
 Themes define colours, icons, font and wallpapers.

    `beautiful.init`(`gears.filesystem.get`_themes_dir() .. "default/theme.lua")
    

 &nbsp;
 This is used later as the default terminal and editor to run.

    terminal = "xterm"
    editor = os.getenv("EDITOR") or "nano"
    editor_cmd = terminal .. " -e " .. editor
    

 Default modkey.
 Usually, Mod4 is the key with a logo between Control and Alt.
 If you do not like this or do not have such a key,
 I suggest you to remap Mod4 to another key using xmodmap or other tools.
 However, you can use another modifier like Mod1, but it may interact with others.

    modkey = "Mod4"
    

## Menu
 &nbsp;
 Create a launcher widget and a main menu

    myawesomemenu = {
       { "hotkeys", function() hotkeys_popup.show_help(nil, `awful.screen.focused`()) end },
       { "manual", terminal .. " -e man awesome" },
       { "edit config", editor_cmd .. " " .. awesome.conffile },
       { "restart", awesome.restart },
       { "quit", function() awesome.quit() end },
    }
    
    mymainmenu = `awful.menu`({ items = { { "awesome", myawesomemenu, `beautiful.awesome`_icon },
                                        { "open terminal", terminal }
                                      }
                            })
    
    mylauncher = `awful.widget.launcher`({ image = `beautiful.awesome`_icon,
                                         menu = mymainmenu })
    

 Menubar configuration

    `menubar.utils.terminal` = terminal -- Set the terminal for applications that require it
    

## Tag layout
 &nbsp;
 Table of layouts to cover with awful.layout.inc, order matters.

    tag.connect_signal("request::default_layouts", function()
        `awful.layout.append`_default_layouts({
            `awful.layout.suit.floating`,
            `awful.layout.suit.tile`,
            `awful.layout.suit.tile.left`,
            `awful.layout.suit.tile.bottom`,
            `awful.layout.suit.tile.top`,
            `awful.layout.suit.fair`,
            `awful.layout.suit.fair.horizontal`,
            `awful.layout.suit.spiral`,
            `awful.layout.suit.spiral.dwindle`,
            `awful.layout.suit.max`,
            `awful.layout.suit.max.fullscreen`,
            `awful.layout.suit.magnifier`,
            `awful.layout.suit.corner.nw`,
        })
    end)
    

## Wallpaper
The AwesomeWM wallpaper module, `awful.wallpaper` support both per-screen wallpaper
and wallpaper across multiple screens. In the default configuration, the `"request::wallpaper"` signal
is emitted everytime a screen is added, moved, resized or when the bars
(`awful.wibar`) are moved.

This is will suited for single-screen wallpapers. If you wish to use multi-screen wallpaper,
it is better to create a global wallpaper object and edit it when the screen change. See
the `add_screen`/`remove_screens` methods and the `screens` property of `awful.wallpaper` for
examples.

    screen.connect_signal("request::wallpaper", function(s)
        `awful.wallpaper` {
            screen = s,
            widget = {
                {
                    image     = `beautiful.wallpaper`,
                    upscale   = true,
                    downscale = true,
                    widget    = `wibox.widget.imagebox`,
                },
                valign = "center",
                halign = "center",
                tiled  = false,
                widget = `wibox.container.tile`,
            }
        }
    end)
    

## Wibar

    

 Keyboard map indicator and switcher

    mykeyboardlayout = `awful.widget.keyboardlayout`()
    

 Create a textclock widget

    mytextclock = `wibox.widget.textclock`()
    

 &nbsp;

    screen.connect_signal("request::desktop_decoration", function(s)
        -- Each screen has its own tag table.
        `awful.tag`({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, `awful.layout.layouts`[1])
    
        -- Create a promptbox for each screen
        s.mypromptbox = `awful.widget.prompt`()
    
        -- Create an imagebox widget which will contain an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = `awful.widget.layoutbox` {
            screen  = s,
            buttons = {
                `awful.button`({ }, 1, function () `awful.layout.inc`( 1) end),
                `awful.button`({ }, 3, function () `awful.layout.inc`(-1) end),
                `awful.button`({ }, 4, function () `awful.layout.inc`(-1) end),
                `awful.button`({ }, 5, function () `awful.layout.inc`( 1) end),
            }
        }
    
        -- Create a taglist widget
        s.mytaglist = `awful.widget.taglist` {
            screen  = s,
            filter  = `awful.widget.taglist.filter.all`,
            buttons = {
                `awful.button`({ }, 1, function(t) t:view_only() end),
                `awful.button`({ modkey }, 1, function(t)
                                                if client.focus then
                                                    client.focus:move_to_tag(t)
                                                end
                                            end),
                `awful.button`({ }, 3, `awful.tag.viewtoggle`),
                `awful.button`({ modkey }, 3, function(t)
                                                if client.focus then
                                                    client.focus:toggle_tag(t)
                                                end
                                            end),
                `awful.button`({ }, 4, function(t) `awful.tag.viewprev`(t.screen) end),
                `awful.button`({ }, 5, function(t) `awful.tag.viewnext`(t.screen) end),
            }
        }
    

 &nbsp;

        -- Create a tasklist widget
        s.mytasklist = `awful.widget.tasklist` {
            screen  = s,
            filter  = `awful.widget.tasklist.filter.currenttags`,
            buttons = {
                `awful.button`({ }, 1, function (c)
                    c:activate { context = "tasklist", action = "toggle_minimization" }
                end),
                `awful.button`({ }, 3, function() `awful.menu.client`_list { theme = { width = 250 } } end),
                `awful.button`({ }, 4, function() `awful.client.focus.byidx`(-1) end),
                `awful.button`({ }, 5, function() `awful.client.focus.byidx`( 1) end),
            }
        }
    

 &nbsp;

        -- Create the wibox
        s.mywibox = `awful.wibar` {
            position = "top",
            screen   = s,

 &nbsp;

            widget   = {
                layout = `wibox.layout.align.horizontal`,
                { -- Left widgets
                    layout = `wibox.layout.fixed.horizontal`,
                    mylauncher,
                    s.mytaglist,
                    s.mypromptbox,
                },
                s.mytasklist, -- Middle widget
                { -- Right widgets
                    layout = `wibox.layout.fixed.horizontal`,
                    mykeyboardlayout,
                    `wibox.widget.systray`(),
                    mytextclock,
                    s.mylayoutbox,
                },
            }
        }
    end)
    
    

## Mouse bindings
 &nbsp;

    `awful.mouse.append`_global_mousebindings({
        `awful.button`({ }, 3, function () mymainmenu:toggle() end),
        `awful.button`({ }, 4, `awful.tag.viewprev`),
        `awful.button`({ }, 5, `awful.tag.viewnext`),
    })
    

## Key bindings
 <a id="global_keybindings" />
 This section stores the global keybindings. A global keybinding is a shortcut
 that will be executed when the key is pressed. It is different from
 <a href="#client_keybindings">client keybindings</a>. A client keybinding
 only works when a client is focused while a global one works all the time.

 Each keybinding is stored in an `awful.key` object. When creating such an
 object, you need to provide a list of modifiers, a key or keycode, a callback
 function and extra metadata used for the `awful.hotkeys_popup` widget.

 Common modifiers are:

 <table class='widget_list' border=1>
  <tr style='font-weight: bold;'>
   <th align='center'>Name</th>
   <th align='center'>Description</th>
  </tr>
  <tr><td>Mod4</td><td>Also called Super, Windows and Command ⌘</td></tr>
  <tr><td>Mod1</td><td>Usually called Alt on PCs and Option on Macs</td></tr>
  <tr><td>Shift</td><td>Both left and right shift keys</td></tr>
  <tr><td>Control</td><td>Also called CTRL on some keyboards</td></tr>
 </table>

 Note that both `Mod2` and `Lock` are ignored by default. If you wish to
 use them, add `awful.key.ignore_modifiers = {}` to your `rc.lua`. `Mod3`,
 `Mod5` are usually not bound in most keyboard layouts. There is an X11 utility
 called `xmodmap` to bind them. See
 [the ARCH Linux Wiki](https://wiki.archlinux.org/index.php/xmodmap) for more
 information.

 The key or keycode is usually the same as the keyboard key, for example:

 * "a"
 * "Return"
 * "Shift_R"

 Each key also has a code. This code depends on the exact keyboard layout. It
 can be obtained by reading the terminal output of the `xev` command. A keycode
 based keybinding will look like `#123` where 123 is the keycode.

 The callback has to be a function. Note that a function isn't the same as a
 function call. If you use, for example, `awful.tag.viewtoggle()` as the
 callback, you store the **result** of the function. If you wish to use that
 function as a callback, just use `awful.tag.viewtoggle`. The same applies to
 methods. If you have to add parameters to the callback, wrap them in another
 function. For the toggle example, this would be
 `function() awful.tag.viewtoggle(mouse.screen.tags[1]) end`.

 Note that global keybinding callbacks have no argument. If you wish to act on
 the current `client`, use the <a href="#client_keybindings">client keybindings</a>
 table.

    

 General Awesome keys

    `awful.keyboard.append`_global_keybindings({
        `awful.key`({ modkey,           }, "s",      hotkeys_popup.show_help,
                  {description="show help", group="awesome"}),
        `awful.key`({ modkey,           }, "w", function () mymainmenu:show() end,
                  {description = "show main menu", group = "awesome"}),
        `awful.key`({ modkey, "Control" }, "r", awesome.restart,
                  {description = "reload awesome", group = "awesome"}),
        `awful.key`({ modkey, "Shift"   }, "q", awesome.quit,
                  {description = "quit awesome", group = "awesome"}),
        `awful.key`({ modkey }, "x",
                  function ()
                      `awful.prompt.run` {
                        prompt       = "Run Lua code: ",
                        textbox      = `awful.screen.focused`().mypromptbox.widget,
                        exe_callback = `awful.util.eval`,
                        history_path = `awful.util.get`_cache_dir() .. "/history_eval"
                      }
                  end,
                  {description = "lua execute prompt", group = "awesome"}),
        `awful.key`({ modkey,           }, "Return", function () `awful.spawn`(terminal) end,
                  {description = "open a terminal", group = "launcher"}),
        `awful.key`({ modkey },            "r",     function () `awful.screen.focused`().mypromptbox:run() end,
                  {description = "run prompt", group = "launcher"}),
        `awful.key`({ modkey }, "p", function() `menubar.show`() end,
                  {description = "show the menubar", group = "launcher"}),
    })
    

 Tags related keybindings

    `awful.keyboard.append`_global_keybindings({
        `awful.key`({ modkey,           }, "Left",   `awful.tag.viewprev`,
                  {description = "view previous", group = "tag"}),
        `awful.key`({ modkey,           }, "Right",  `awful.tag.viewnext`,
                  {description = "view next", group = "tag"}),
        `awful.key`({ modkey,           }, "Escape", `awful.tag.history.restore`,
                  {description = "go back", group = "tag"}),
    })
    

 Focus related keybindings

    `awful.keyboard.append`_global_keybindings({
        `awful.key`({ modkey,           }, "j",
            function ()
                `awful.client.focus.byidx`( 1)
            end,
            {description = "focus next by index", group = "client"}
        ),
        `awful.key`({ modkey,           }, "k",
            function ()
                `awful.client.focus.byidx`(-1)
            end,
            {description = "focus previous by index", group = "client"}
        ),
        `awful.key`({ modkey,           }, "Tab",
            function ()
                `awful.client.focus.history.previous`()
                if client.focus then
                    client.focus:raise()
                end
            end,
            {description = "go back", group = "client"}),
        `awful.key`({ modkey, "Control" }, "j", function () `awful.screen.focus`_relative( 1) end,
                  {description = "focus the next screen", group = "screen"}),
        `awful.key`({ modkey, "Control" }, "k", function () `awful.screen.focus`_relative(-1) end,
                  {description = "focus the previous screen", group = "screen"}),
        `awful.key`({ modkey, "Control" }, "n",
                  function ()
                      local c = `awful.client.restore`()
                      -- Focus restored client
                      if c then
                        c:activate { raise = true, context = "key.unminimize" }
                      end
                  end,
                  {description = "restore minimized", group = "client"}),
    })
    

 Layout related keybindings

    `awful.keyboard.append`_global_keybindings({
        `awful.key`({ modkey, "Shift"   }, "j", function () `awful.client.swap.byidx`(  1)    end,
                  {description = "swap with next client by index", group = "client"}),
        `awful.key`({ modkey, "Shift"   }, "k", function () `awful.client.swap.byidx`( -1)    end,
                  {description = "swap with previous client by index", group = "client"}),
        `awful.key`({ modkey,           }, "u", `awful.client.urgent.jumpto`,
                  {description = "jump to urgent client", group = "client"}),
        `awful.key`({ modkey,           }, "l",     function () `awful.tag.incmwfact`( 0.05)          end,
                  {description = "increase master width factor", group = "layout"}),
        `awful.key`({ modkey,           }, "h",     function () `awful.tag.incmwfact`(-0.05)          end,
                  {description = "decrease master width factor", group = "layout"}),
        `awful.key`({ modkey, "Shift"   }, "h",     function () `awful.tag.incnmaster`( 1, nil, true) end,
                  {description = "increase the number of master clients", group = "layout"}),
        `awful.key`({ modkey, "Shift"   }, "l",     function () `awful.tag.incnmaster`(-1, nil, true) end,
                  {description = "decrease the number of master clients", group = "layout"}),
        `awful.key`({ modkey, "Control" }, "h",     function () `awful.tag.incncol`( 1, nil, true)    end,
                  {description = "increase the number of columns", group = "layout"}),
        `awful.key`({ modkey, "Control" }, "l",     function () `awful.tag.incncol`(-1, nil, true)    end,
                  {description = "decrease the number of columns", group = "layout"}),
        `awful.key`({ modkey,           }, "space", function () `awful.layout.inc`( 1)                end,
                  {description = "select next", group = "layout"}),
        `awful.key`({ modkey, "Shift"   }, "space", function () `awful.layout.inc`(-1)                end,
                  {description = "select previous", group = "layout"}),
    })
    

 &nbsp;

    
    `awful.keyboard.append`_global_keybindings({
        `awful.key` {
            modifiers   = { modkey },
            keygroup    = "numrow",
            description = "only view tag",
            group       = "tag",
            on_press    = function (index)
                local screen = `awful.screen.focused`()
                local tag = screen.tags[index]
                if tag then
                    tag:view_only()
                end
            end,
        },
        `awful.key` {
            modifiers   = { modkey, "Control" },
            keygroup    = "numrow",
            description = "toggle tag",
            group       = "tag",
            on_press    = function (index)
                local screen = `awful.screen.focused`()
                local tag = screen.tags[index]
                if tag then
                    `awful.tag.viewtoggle`(tag)
                end
            end,
        },
        `awful.key` {
            modifiers = { modkey, "Shift" },
            keygroup    = "numrow",
            description = "move focused client to tag",
            group       = "tag",
            on_press    = function (index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
        },
        `awful.key` {
            modifiers   = { modkey, "Control", "Shift" },
            keygroup    = "numrow",
            description = "toggle focused client on tag",
            group       = "tag",
            on_press    = function (index)
                if client.focus then
                    local tag = client.focus.screen.tags[index]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
        },
        `awful.key` {
            modifiers   = { modkey },
            keygroup    = "numpad",
            description = "select layout directly",
            group       = "layout",
            on_press    = function (index)
                local t = `awful.screen.focused`().selected_tag
                if t then
                    t.layout = t.layouts[index] or t.layout
                end
            end,
        }
    })
    

 &nbsp;

    client.connect_signal("request::default_mousebindings", function()
        `awful.mouse.append`_client_mousebindings({
            `awful.button`({ }, 1, function (c)
                c:activate { context = "mouse_click" }
            end),
            `awful.button`({ modkey }, 1, function (c)
                c:activate { context = "mouse_click", action = "mouse_move"  }
            end),
            `awful.button`({ modkey }, 3, function (c)
                c:activate { context = "mouse_click", action = "mouse_resize"}
            end),
        })
    end)
    

 <a id="client_keybindings" />

 A client keybinding is a shortcut that will get the currently focused client
 as its first callback argument. For example, to toggle a property, the callback
 will look like `function(c) c.sticky = not c.sticky end`. For more information
 about the keybinding syntax, see the
 <a href="#global_keybindings">global keybindings</a> section.

    client.connect_signal("request::default_keybindings", function()
        `awful.keyboard.append`_client_keybindings({
            `awful.key`({ modkey,           }, "f",
                function (c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end,
                {description = "toggle fullscreen", group = "client"}),
            `awful.key`({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
                    {description = "close", group = "client"}),
            `awful.key`({ modkey, "Control" }, "space",  `awful.client.floating.toggle`                     ,
                    {description = "toggle floating", group = "client"}),
            `awful.key`({ modkey, "Control" }, "Return", function (c) c:swap(`awful.client.getmaster`()) end,
                    {description = "move to master", group = "client"}),
            `awful.key`({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
                    {description = "move to screen", group = "client"}),
            `awful.key`({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
                    {description = "toggle keep on top", group = "client"}),
            `awful.key`({ modkey,           }, "n",
                function (c)
                    -- The client currently has the input focus, so it cannot be
                    -- minimized, since minimized clients can't have the focus.
                    c.minimized = true
                end ,
                {description = "minimize", group = "client"}),
            `awful.key`({ modkey,           }, "m",
                function (c)
                    c.maximized = not c.maximized
                    c:raise()
                end ,
                {description = "(un)maximize", group = "client"}),
            `awful.key`({ modkey, "Control" }, "m",
                function (c)
                    c.maximized_vertical = not c.maximized_vertical
                    c:raise()
                end ,
                {description = "(un)maximize vertically", group = "client"}),
            `awful.key`({ modkey, "Shift"   }, "m",
                function (c)
                    c.maximized_horizontal = not c.maximized_horizontal
                    c:raise()
                end ,
                {description = "(un)maximize horizontally", group = "client"}),
        })
    end)
    
    

## Rules
 Rules to apply to new clients.
 &nbsp;

    ruled.client.connect_signal("request::rules", function()

 &nbsp;

        -- All clients will match this rule.
        ruled.client.append_rule {
            id         = "global",
            rule       = { },
            properties = {
                focus     = `awful.client.focus.filter`,
                raise     = true,
                screen    = `awful.screen.preferred`,
                placement = `awful.placement.no`_overlap+`awful.placement.no`_offscreen
            }
        }
    

 &nbsp;

        -- Floating clients.
        ruled.client.append_rule {
            id       = "floating",
            rule_any = {
                instance = { "copyq", "pinentry" },
                class    = {
                    "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                    "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
                },
                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name    = {
                    "Event Tester",  -- xev.
                },
                role    = {
                    "AlarmWindow",    -- Thunderbird's calendar.
                    "ConfigManager",  -- Thunderbird's about:config.
                    "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
                }
            },
            properties = { floating = true }
        }
    

 &nbsp;

        -- Add titlebars to normal clients and dialogs
        ruled.client.append_rule {

 For client side decorations, clients might request no titlebars via
 Motif WM hints. To honor these hints, use:
 `titlebars_enabled = function(c) return not c.requests_no_titlebar end`

 See `client.requests_no_titlebar` for more details.

            id         = "titlebars",
            rule_any   = { type = { "normal", "dialog" } },
            properties = { titlebars_enabled = true      }
        }
    
        -- Set Firefox to always map on the tag named "2" on screen 1.
        -- ruled.client.append_rule {
        --     rule       = { class = "Firefox"     },
        --     properties = { screen = 1, tag = "2" }
        -- }
    end)
    

## Titlebars
 &nbsp;
 Add a titlebar if titlebars_enabled is set to true in the rules.

    client.connect_signal("request::titlebars", function(c)
        -- buttons for the titlebar
        local buttons = {
            `awful.button`({ }, 1, function()
                c:activate { context = "titlebar", action = "mouse_move"  }
            end),
            `awful.button`({ }, 3, function()
                c:activate { context = "titlebar", action = "mouse_resize"}
            end),
        }
    
        `awful.titlebar`(c).widget = {
            { -- Left
                `awful.titlebar.widget.iconwidget`(c),
                buttons = buttons,
                layout  = `wibox.layout.fixed.horizontal`
            },
            { -- Middle
                { -- Title
                    halign = "center",
                    widget = `awful.titlebar.widget.titlewidget`(c)
                },
                buttons = buttons,
                layout  = `wibox.layout.flex.horizontal`
            },
            { -- Right
                `awful.titlebar.widget.floatingbutton` (c),
                `awful.titlebar.widget.maximizedbutton`(c),
                `awful.titlebar.widget.stickybutton`   (c),
                `awful.titlebar.widget.ontopbutton`    (c),
                `awful.titlebar.widget.closebutton`    (c),
                layout = `wibox.layout.fixed.horizontal`()
            },
            layout = `wibox.layout.align.horizontal`
        }
    end)
    

## Notifications

    
    ruled.notification.connect_signal('request::rules', function()
        -- All notifications will match this rule.
        ruled.notification.append_rule {
            rule       = { },
            properties = {
                screen           = `awful.screen.preferred`,
                implicit_timeout = 5,
            }
        }
    end)
    
    `naughty.connect`_signal("request::display", function(n)
        `naughty.layout.box` { notification = n }
    end)
    
    

 Enable sloppy focus, so that focus follows mouse.

    client.connect_signal("mouse::enter", function(c)
        c:activate { context = "mouse_enter", raise = false }
    end)

