_WHEEL_BUILD_FILE_CONTENT = """
py_library(
    name = "lib",
    srcs = glob(["**/*.py"]),
    data = glob(
        ["**/*"],
        exclude = [
            "**/*.py",
            "**/* *",  # Bazel runfiles cannot have spaces in the name
            "BUILD",
            "WORKSPACE",
            "*.whl.zip",
        ],
    ),
    imports = ["."],
    visibility = ["//visibility:public"],
)
"""


def _pip_repositories_impl(repo_ctx):
    result = repo_ctx.execute([
        repo_ctx.path(repo_ctx.attr._generate_pip_repositories),
        repo_ctx.path(repo_ctx.attr.requirements),
        repo_ctx.path("requirements.bzl"),
        repo_ctx.path("BUILD"),
        repo_ctx.attr.rules_pip_repo_name,
    ])
    if result.return_code:
        fail(result.stderr)


pip_repositories = repository_rule(
    implementation = _pip_repositories_impl,
    attrs = {
        "requirements": attr.label(allow_single_file = True),
        "rules_pip_repo_name": attr.string(default = "com_apt_itude_rules_pip"),
        "_generate_pip_repositories": attr.label(
            default = "//src/bin:generate_pip_repositories.py",
            executable = True,
            cfg = "host",
        ),
    }
)


def _remote_wheel_impl(repo_ctx):
    repo_ctx.download_and_extract(
        url = repo_ctx.attr.url,
        sha256 = repo_ctx.attr.sha256,
        type = "zip",
    )

    _generate_wheel_build_file(repo_ctx)


def _generate_wheel_build_file(repo_ctx):
    repo_ctx.file(repo_ctx.path("BUILD"), content = _WHEEL_BUILD_FILE_CONTENT)


remote_wheel = repository_rule(
    implementation = _remote_wheel_impl,
    attrs = {
        "url": attr.string(mandatory = True),
        "sha256": attr.string(),
    }
)


def _local_wheel_impl(repo_ctx):
    # Symlink to the wheel because the "extract" function doesn't know what to do with
    # the .whl extension
    repo_ctx.symlink(repo_ctx.attr.wheel, "wheel.zip")

    repo_ctx.extract(archive = "wheel.zip")

    _generate_wheel_build_file(repo_ctx)


local_wheel = repository_rule(
    implementation = _local_wheel_impl,
    attrs = {
        "wheel": attr.label(mandatory = True),
    }
)
