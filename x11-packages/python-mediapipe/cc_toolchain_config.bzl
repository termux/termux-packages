load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
)
load("@rules_cc//cc/common:cc_common.bzl", "cc_common")
load("@rules_cc//cc:defs.bzl", "CcToolchainConfigInfo")

all_link_actions = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]

all_compile_actions = [
    ACTION_NAMES.assemble,
    ACTION_NAMES.c_compile,
    ACTION_NAMES.clif_match,
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.lto_backend,
    ACTION_NAMES.preprocess_assemble,
]

all_cxx_compile_actions = [
    ACTION_NAMES.clif_match,
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.lto_backend,
]

def _impl(ctx):
    prefix_root = ctx.files.prefix_files[0].owner.workspace_root
    toolchain_root = ctx.files.toolchain_files[0].owner.workspace_root

    tool_paths = [
        tool_path(name = "ar", path = "bin/@AR@"),
        tool_path(name = "cpp", path = "bin/@CPP@"),
        tool_path(name = "gcc", path = "bin/@CC@"),
        tool_path(name = "gcov", path = "/bin/false"),
        tool_path(name = "g++", path = "bin/@CXX@"),
        tool_path(name = "ld", path = "bin/@LD@"),
        tool_path(name = "nm", path = "bin/@NM@"),
        tool_path(name = "objdump", path = "bin/@OBJDUMP@"),
        tool_path(name = "strip", path = "bin/@STRIP@"),
    ]

    default_compiler_flags = feature(
        name = "default_compiler_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-fPIC",
                            "--sysroot=" + toolchain_root + "/sysroot",
                            "-isystem" + prefix_root + "/include",
                            "-no-canonical-prefixes",
                        ],
                    ),
                ],
            ),
            flag_set(
                actions = all_cxx_compile_actions,
                flag_groups = [
                    flag_group(
                        expand_if_available = "cxx_flags",
                        flags = ["%{cxx_flags}"],
                        iterate_over = "cxx_flags",
                    ),
                ],
            ),
        ],
    )

    default_linker_flags = feature(
        name = "default_linker_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-Wl,-rpath=@TERMUX_PREFIX@/lib",
                            "-L" + prefix_root + "/lib",
                            "--sysroot=" + toolchain_root + "/sysroot/",
                            "-lc++_shared",
                        ],
                    ),
                ],
            ),
        ],
    )

    user_compile_flags = feature(
        name = "user_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions,
                flag_groups = [
                    flag_group(
                        expand_if_available = "user_compile_flags",
                        flags = ["%{user_compile_flags}"],
                        iterate_over = "user_compile_flags",
                    ),
                ],
            ),
        ],
    )

    user_link_flags = feature(
        name = "user_link_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = [
                    flag_group(
                        expand_if_available = "user_link_flags",
                        flags = ["%{user_link_flags}"],
                        iterate_over = "user_link_flags",
                    ),
                ],
            ),
        ],
    )

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = [
            default_compiler_flags,
            default_linker_flags,
            user_compile_flags,
            user_link_flags,
        ],
        toolchain_identifier = "@TERMUX_ARCH@-toolchain",
        host_system_name = "local",
        target_system_name = "unknown",
        target_cpu = "unknown",
        target_libc = "unknown",
        compiler = "unknown",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
    )

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "prefix_files": attr.label_list(allow_files = True),
        "toolchain_files": attr.label_list(allow_files = True),
    },
    provides = [CcToolchainConfigInfo],
)
