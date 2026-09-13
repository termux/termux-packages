load("@rules_cc//cc/toolchains:cc_toolchain.bzl", "cc_toolchain")
load("@rules_cc//cc/toolchains:cc_toolchain_suite.bzl", "cc_toolchain_suite")
load(":cc_toolchain_config.bzl", "cc_toolchain_config")

package(default_visibility = ["//visibility:public"])

filegroup(name = "empty")

filegroup(
    name = "bootstrap",
    srcs = glob(["bin/**"]) + [
        "@termux-prefix//:prefix",
        "@termux-toolchain//:toolchain",
    ],
)

cc_toolchain_config(name = "@TERMUX_ARCH@_toolchain_config")

cc_toolchain(
    name = "@TERMUX_ARCH@_toolchain",
    all_files = ":bootstrap",
    ar_files = ":bootstrap",
    compiler_files = ":bootstrap",
    dwp_files = ":bootstrap",
    linker_files = ":bootstrap",
    objcopy_files = ":bootstrap",
    strip_files = ":bootstrap",
    toolchain_config = ":@TERMUX_ARCH@_toolchain_config",
    toolchain_identifier = "@TERMUX_ARCH@-toolchain",
)

cc_toolchain_suite(
    name = "gcc_toolchain",
    tags = ["manual"],
    toolchains = {
        "@TERMUX_ARCH@": ":@TERMUX_ARCH@_toolchain",
    },
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
