load("//mods:def.bzl", "module")
load("//mods/extras:build.bzl", "build_trigger")

module(
    name = "app",
    srcs = ["main.py"],
    deps = [
        "//examples/common",
    ],
)

build_trigger(
    name = "trigger",
    deps = [":app"],
)
