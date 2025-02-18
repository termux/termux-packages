---
page_ref: "@ARK_PROJECT__VARIANT@/termux/termux-packages/docs/@ARK_DOC__VERSION@/repos/main/packages/termux-tools/logcat/index.html"
---

# Logcat

<!-- @ARK_DOCS__HEADER_PLACEHOLDER@ -->

The `$PREFIX/bin/logcat` command is provided by the [`termux-tools`](../index.html) package as a wrapper for the system provided `/system/bin/logcat` binary.

**Source:** https://github.com/termux/termux-tools/blob/master/scripts/login.in

&nbsp;

Logcat is a command-line tool that dumps a log of system messages that Termux apps, other apps or Android system may log. For more information, check official Android `logcat` guide [here](https://developer.android.com/studio/command-line/logcat).

Some problems of the Termux app, plugins and packages can be debugged by checking `Exception`s and errors in the Android `logcat` dump. Devs may also ask for these logs for certain issues.

&nbsp;



### App Log levels

The Termux apps log information to `logcat` depending on the `Log Level` set in `Termux` app settings -> `<APP_NAME>` -> `Debugging` -> `Log Level` (Requires `Termux` app version `>= 0.118.0`). The `Log Level` defaults to `Normal` and higher log levels like `Verbose` will log additional information. It is best to revert log level to `Normal` after you have finished debugging since private data may keep getting logged to `logcat` during normal operation and moreover, additional logging increases execution time.

The **shell commands** that can be run with plugin apps are not executed by plugin apps themselves, but they instead send execution intents to the Termux app, which has its own log level which can be set in `Termux` app settings -> `Termux` -> `Debugging` -> `Log Level`. So you must set log level for both `Termux` and the respective plugin app to get all the info.

- `Off` - Log nothing.
- `Normal` - Start logging error, warn and info messages and stacktraces.
- `Debug` - Start logging debug messages.
- `Verbose` - Start logging verbose messages.

## &nbsp;

&nbsp;



### Getting logs

<!-- FIXME: Use: `@TERMUX_APP__SHARED_USER_ID@` -->

Once log levels have been set, you can run the `logcat` command to get the logs. **Note that by default, an app can only get its own logs and that of any app that has the same [`sharedUserId`](https://developer.android.com/guide/topics/manifest/manifest-element#uid) as it, but it cannot get the full system logs of other apps and the Android system.** Since the Termux app only has the same `sharedUserId` (`com.termux`) as the `Termux:API`, `Termux:Boot`, `Termux:Styling`, `Termux:Tasker` and `Termux:Widget` apps, it can only view the logs of these apps.

**To get full system logs of other apps and the Android system, the `logcat` command needs to be run with `root` or `adb`**, or the app needs to be granted the [`RAED_LOGS`](https://developer.android.com/reference/android/Manifest.permission#READ_LOGS) permission with `root` or `adb`. **This may be necessary for solving specific issues** as some `Exception`s and errors which may affect the Termux apps are only logged by the Android system or by other apps.

#### To get logs of Termux apps

- Use the long hold on the terminal -> `More` -> `Report issue` option and selecting `YES` in the prompt shown to add debug info to generate Termux files `stat` info and `logcat` dump automatically. If the report generated is too large, then `Save To File` option in context menu (3 dots on top right) of report activity can be used and the file viewed/shared instead.
- Run `logcat -d > /sdcard/logcat.txt` in the terminal of the Termux app to log a dump to the sdcard, which will require storage permission to be granted to the Termux app.

#### To get full system logs of other apps and the Android system

- Run `su -c "logcat -d > /sdcard/logcat.txt"` in the Termux app terminal to log a dump to the sdcard if the Termux app has root access.
- Run `adb shell "logcat -d > /sdcard/logcat.txt"` in the Termux app terminal to log a dump to the sdcard if `adb` wireless debugging has been set up for the Termux app with the [`android-tools`](https://www.reddit.com/r/termux/comments/mmu2iu/announce_adb_is_now_packaged_for_termux) package.
- Run `adb logcat -d > logcat.txt"` in the PC terminal to log a dump to current directory if `adb` usb or wireless debugging has been set up.

For setting up `adb`, check Android guide [here](https://developer.android.com/tools/adb).

The `-d` option in the `logcat -d` commands above mean to dump the entire current `logcat` buffer to `stdout` and exit. If you do not pass it, then logs will keep getting logged to `stdout` until `ctrl+c` is pressed to exit the `logcat` command manually.

You can also use the `logcat -c` command before reproducing an issue to clear the `logcat` buffer to remove old entries from the buffer so that only entries after the last clear command are logged when you later run `logcat -d` command. This can be useful if `logcat` dump is too large and you only want recent entries.

## &nbsp;

&nbsp;



### Privacy

The `Termux` apps will log configuration and output (`stdout`/`stderr`) of action and shell commands to `logcat` if log level is `> NORMAL`. Since other apps or the Android system may be able to read the logs, it is advisable not to keep log `> NORMAL` under normal operation.

Moreover, since Termux, other apps or the Android system may be logging sensitive info the `logcat`, do not post logs publicly on the internet without removing any such information first. However, since an average may not know what is sensitive or not, either only post parts of the logs that are asked to reduce risk or send the logs in an email or private message directly to the dev, assuming you trust them.

## &nbsp;

&nbsp;



### SeLinux denials

Some `Permission denied` errors may be due to [Android SeLinux](https://source.android.com/docs/security/features/selinux) policies. To find out if that is the case, you can see if any `avc: denied` messages are being logged in `logcat` for the command process. Some messages will require running `logcat` command with `root`, `adb` or [`RAED_LOGS`](https://developer.android.com/reference/android/Manifest.permission#READ_LOGS) permission since they are not logged at the app level.

**You may also need to disable `SELinux` rate limit with `su -c auditctl -r 0` to show all denials, but that requires `root` access.** This is often needed because when a shell command is run, multiple entries for the unrelated denial of the [`search`](https://selinuxproject.org/page/NB_ObjectClassesPermissions) permission for the `dir` class for the files under the [`/data/local/tests`](https://cs.android.com/android/platform/superproject/+/android-14.0.0_r1:system/sepolicy/private/file_contexts;l=570) directory that are assigned the [`shell_test_data_file`](https://cs.android.com/android/platform/superproject/+/android-14.0.0_r1:system/sepolicy/public/file.te;l=368) type are logged first, and so the rate limit hits preventing logging of the required/useful denials. You will see an entry like `avc:  denied  { search } for  name="tests" dev="dm-50" ino=113 scontext=u:r:untrusted_app:s0:cXXX,c257,c512,c768 tcontext=u:object_r:shell_test_data_file:s0 tclass=dir`. The SeLinux policy can be patched to disable logging of such denials by running `su -c 'supolicy --live "dontaudit untrusted_app shell_test_data_file dir search"'` with [Magisk `supolicy`](https://topjohnwu.github.io/Magisk/tools.html#magiskpolicy) tool or related.

Check Android docs [here](https://source.android.com/docs/security/features/selinux/validate#reading_denials) for more info on denials.

## &nbsp;

&nbsp;
