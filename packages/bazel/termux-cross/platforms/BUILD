package(default_visibility = ["//visibility:public"])

constraint_setting(
    name = "target_app",
    default_constraint_value = ":unknown",
)

constraint_value(
    name = "termux",
    constraint_setting = ":target_app",
)

constraint_value(
    name = "unknown",
    constraint_setting = ":target_app",
)

platform(
    name = "termux_aarch64",
    constraint_values = [
        ":termux",
        "@platforms//cpu:aarch64",
        "@platforms//os:linux",
    ],
)

platform(
    name = "termux_arm",
    constraint_values = [
        ":termux",
        "@platforms//cpu:armv7",
        "@platforms//os:linux",
    ],
)

platform(
    name = "termux_i686",
    constraint_values = [
        ":termux",
        "@platforms//cpu:i686",
        "@platforms//os:linux",
    ],
)

platform(
    name = "termux_x86_64",
    constraint_values = [
        ":termux",
        "@platforms//cpu:x86_64",
        "@platforms//os:linux",
    ],
)
