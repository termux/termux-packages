package(default_visibility = ["//visibility:public"])

load(":cc_toolchain_config.bzl", "cc_toolchain_config")

filegroup(name = "empty")

filegroup(
  name = "bootstrap",
  srcs = glob(["bin/**"]) + [
    "@termux-toolchain//:toolchain",
    "@termux-prefix//:prefix",
  ],
)

cc_toolchain_config(name = "@TERMUX_ARCH@_toolchain_config")

cc_toolchain(
    name = "@TERMUX_ARCH@_toolchain",
    toolchain_identifier = "@TERMUX_ARCH@-toolchain",
    toolchain_config = ":@TERMUX_ARCH@_toolchain_config",
    all_files = ":bootstrap",
    ar_files = ":bootstrap",
    compiler_files = ":bootstrap",
    dwp_files = ":bootstrap",
    linker_files = ":bootstrap",
    objcopy_files = ":bootstrap",
    strip_files = ":bootstrap",
)

cc_toolchain_suite(
    name = "gcc_toolchain",
    toolchains = {
        "@TERMUX_ARCH@": ":@TERMUX_ARCH@_toolchain",
    },
    tags = ["manual"]
)

toolchain(
    name = "@TERMUX_ARCH@_linux_toolchain",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@//termux-cross/platforms:termux",
        "@platforms//os:linux",
        "@platforms//cpu:@TERMUX_ARCH@",
    ],
    toolchain = ":@TERMUX_ARCH@_toolchain",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)
