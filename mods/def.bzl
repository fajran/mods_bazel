ModuleInfo = provider(fields = ["files"])

def _module_impl(ctx):
    files = []
    for src in ctx.files.srcs:
        if not src.is_source:
            fail("srcs only accept files")
        files.append(src)
    for dep in ctx.attr.deps:
        files += dep[ModuleInfo].files

    param = struct(
        files = [f.path for f in files],
    )
    param_file = ctx.actions.declare_file(ctx.label.name + ".param.json")
    ctx.actions.write(param_file, param.to_json())

    ctx.actions.run(
        executable = ctx.executable.file_hasher,
        inputs = files + [param_file],
        outputs = [ctx.outputs.out],
        mnemonic = "Module",
        arguments = [param_file.path, ctx.outputs.out.path],
    )

    return [ModuleInfo(files=files)]

def new_module():
    return rule(
        attrs = {
            "srcs": attr.label_list(
                allow_files = True,
                default = [],
            ),
            "deps": attr.label_list(
                allow_files = False,
                default = [],
                providers = [ModuleInfo],
            ),
            "file_hasher": attr.label(
                default = Label("//mods:file_hasher"),
                executable = True,
                allow_files = True,
                cfg = "host",
            ),
        },
        outputs = {
            "out": "%{name}.json",
        },
        implementation = _module_impl,
    )

module = new_module()
