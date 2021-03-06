load("@pip//pyang:repos.bzl", pyang_repo = "all")

py_test(
    name = "conditional_dependencies_test_py2",
    srcs = ["conditional_dependencies_test.py"],
    main = "conditional_dependencies_test.py",
    deps = [
        "@pip//isort",
        "@pip//pathlib2",
    ],
    python_version = "PY2",
    tags = ["new"],
)

py_test(
    name = "conditional_dependencies_test_py3",
    srcs = ["conditional_dependencies_test.py"],
    main = "conditional_dependencies_test.py",
    deps = ["@pip//isort"],
    python_version = "PY3",
    tags = ["new"],
)


py_test(
    name = "local_wheel_test_py2",
    srcs = ["local_wheel_test.py"],
    main = "local_wheel_test.py",
    deps = ["@pip//pyyaml"],
    python_version = "PY2",
    tags = ["new"],
)

py_test(
    name = "local_wheel_test_py3",
    srcs = ["local_wheel_test.py"],
    main = "local_wheel_test.py",
    deps = ["@pip//pyyaml"],
    python_version = "PY3",
    tags = ["new"],
)


py_test(
    name = "multi_platform_multi_python_dep_test_py2",
    srcs = ["multi_platform_multi_python_dep_test.py"],
    main = "multi_platform_multi_python_dep_test.py",
    deps = ["@pip//lxml"],
    python_version = "PY2",
    tags = ["new"],
)

py_test(
    name = "multi_platform_multi_python_dep_test_py3",
    srcs = ["multi_platform_multi_python_dep_test.py"],
    main = "multi_platform_multi_python_dep_test.py",
    deps = ["@pip//lxml"],
    python_version = "PY3",
    tags = ["new"],
)

py_test(
    name = "visibility_test",
    srcs = ["visibility_test.py"],
    data = [
        ":visibility_test_pytest_six",
        ":visibility_test_lib_six",
    ],
)

genquery(
    name = "visibility_test_pytest_six",
    expression = "visible('@pip//pytest', '@pip//six')",
    scope = ["@pip//pytest"],
)

py_library(
    name = "visibility_test_library",
    deps = ["@pip//pytest"],
)

genquery(
    name = "visibility_test_lib_six",
    expression = "visible('//test:visibility_test_library', '@pip//six')",
    scope = [":visibility_test_library"],
)

genrule(
    name = "pyang-main",
    srcs = [pyang_repo + "//scripts:pyang"],
    outs = ["pyang-main.py"],
    cmd = "cp $< $@",
)

py_binary(
    name = "pyang-exe",
    srcs = [":pyang-main"],
    main = "pyang-main.py",
    deps = ["@pip//pyang"],
    python_version = "PY2",
)

genrule(
    name = "test-yin",
    srcs = [pyang_repo + "//data/share/yang/modules/ietf:ietf-yang-metadata.yang"],
    outs = ["ietf-yang-metadata-generated.yin"],
    tools = [":pyang-exe"],
    cmd = "$(location :pyang-exe) -f yin -o $@ $<",
)

py_test(
    name = "data_test",
    srcs = ["data_test.py"],
    data = [
        "ietf-yang-metadata.yin",
        ":test-yin",
    ],
    python_version = "PY3",
    tags = ["new"],
)

py_test(
    name = "extras_test_py2",
    srcs = ["extras_test.py"],
    main = "extras_test.py",
    deps = [
        "@pip//google_cloud_logging",
        "@pip//isort",
    ],
    python_version = "PY2",
    tags = ["new"],
)

py_test(
    name = "extras_test_py3",
    srcs = ["extras_test.py"],
    main = "extras_test.py",
    deps = [
        "@pip//google_cloud_logging",
        "@pip//isort"
    ],
    python_version = "PY3",
    tags = ["new"],
)
