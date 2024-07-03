# Configuration file for the Sphinx documentation builder.
#
# Reference documentation:
#   https://www.sphinx-doc.org/en/master/usage/configuration.html
#
# -- Project information -----------------------------------------------------
#
project = 'hashistack'
copyright = '2024, WeScale.fr'
author = 'WeScale.fr'
version = '0.8'
release = '0.8'
#
# -- General configuration ---------------------------------------------------
#
extensions = [
    "myst_parser",
    "sphinx.ext.intersphinx",
    "sphinx.ext.autodoc",
    "sphinx.ext.mathjax",
    "sphinx.ext.viewcode",
    "sphinx_copybutton"
]



myst_heading_anchors = 4

copybutton_selector = "div:not(.no-copybutton) > div.highlight > pre"
copybutton_prompt_text = "> "

templates_path = ['_templates']
exclude_patterns = []
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}
#
# -- Options for HTML output -------------------------------------------------
#
html_theme = "furo"
html_title = "HashiStack"
html_logo = "images/hashistack.png"
html_theme_options = {
    "light_css_variables": {
        "admonition-title-font-size": "1.3rem",
        "admonition-font-size": "1.2rem",
    },
    "dark_css_variables": {
        "admonition-title-font-size": "1.3rem",
        "admonition-font-size": "1.2rem",
    },
}
# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
# html_static_path = ['_static']
#
# -- Ansible role inline doc extraction --------------------------------------
#
import os, sys, yaml2md

ignore_role_list = [
    'cloudalchemy.grafana',
    'cloudalchemy.node_exporter',
    'cloudalchemy.prometheus',
    'wescale.hashistack.common_vars',
    'vault'
]
roles_src_path = "../../roles"
roles_doc_path = "reference/roles/role"

for element in os.listdir(roles_src_path):
    if not os.path.isdir(roles_src_path + "/" + element + "/defaults") or element in ignore_role_list:
        continue
    os_walk = os.walk(roles_src_path + "/" + element + "/defaults")
    for path, subdirs, files in os_walk:
        for filename in files:
            if filename.startswith("."):
                continue

            defaults_file = os.path.join(path, filename)

            if element.endswith('_vars'):
                actual_element = element.replace('_vars', '')
            else:
                actual_element = element

            defaults_dir = roles_doc_path + "_" + actual_element

            yaml2md.convert_file(
                defaults_file,
                roles_doc_path + "_" + actual_element + ".md",
                strip_regex=r"\s*(:?\[{3}|\]{3})\d?$",
                yaml_strip_regex=r"^\s{66,67}#\s\]{3}\d?$",
            )
            print("Converted {0}".format(defaults_dir))
