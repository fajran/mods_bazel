Mods
====

Bazel rules to define modules in a monorepo not managed by Bazel.


Background
----------

One of the problem when using monorepo approach is about running build of the
modules in a Continuous Integration system. We often do not want to run build
pipelines of all modules but only of those that are affected by changes made in
commit.

There are build tools that support monorepo development workflow, for example
Bazel. However, often we just want to use existing build tools instead of
migrating to Bazel because it's more familar, or s more supported by IDE, or
other reasons.

This Bazel rule, allows developers to (ab)use Bazel by using its excellent
dependency tracking and query to support monorepo development workflow while
still using more mainstream build tools. Here, Bazel is not used to build the
modules but only to track changes of the modules.


Usage
-----

Add the following into the `WORKSPACE` file

```python
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "mods",
    remote = "https://github.com/fajran/mods_bazel.git",
    commit = "1048864b7dfe3d3d7f02d7c64103843ac4e38cbc",
)
```

To declare a module, add the following to the `BUILD` file of that module.

```python
load("@mods//mods:def.bzl", "module")

module(
    name = "library",
    srcs = glob(["**"]),
)
```

To declare another module and set dependency, add the following.

```python
load("@mods//mods:def.bzl", "module")

module(
    name = "service",
    srcs = glob(["**"]),
    deps = ["//common:library"],  # pointing to the previous 'library' module
)
```


Use Cases
---------

1. Find all modules

    ```bash
    bazel query "kind(module, //...)"
    ```

2. Find all buildable modules

    For this we are going to use a custom rule called `build_trigger` available
    from `//mods/extras:build.bzl`.

    Why new rule? The idea is of all modules that we define using `module`
    rule, some may want to be built in a CI system and some other don't.  To be
    able to query these buildable modules, we can create a new rule with
    different name so they don't get mixed up.

    ```bash
    bazel query "kind(build_trigger, //...)"
    ```

3. Find affected buildable modules from a commit

    Run this from the root git project directory. Add `--keep_going` to recover
    from failures and get as much as possible.

    ```bash
    bazel query --keep_going "kind(build_trigger, rdeps(//..., set($(git diff --name-only HEAD^))))"
    ```

