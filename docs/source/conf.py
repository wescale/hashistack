# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

project = 'mdtest'
copyright = '2022, am'
author = 'am'

# The full version, including alpha/beta/rc tags
release = '0.0.1'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    "myst_parser",
    "sphinx.ext.intersphinx",
    "sphinx.ext.autodoc",
    "sphinx.ext.mathjax",
    "sphinx.ext.viewcode"
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = "furo"
html_logo = "images/logo-oss.png"
# html_static_path = ["_static"]

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
# html_static_path = ['_static']

import os, sys
try:
    sys.path.insert(0, os.getenv("DIRENV_PYTHON_LIBS_DIR"))
    import yaml2rst
except ImportError:
    raise ImportError("yaml2rst import error")


roles_src_path = os.getenv("ANSIBLE_ROLES_PATH")
if not roles_src_path:
    roles_src_path = "../../roles"
roles_doc_path = "reference/role"

for element in os.listdir(roles_src_path):
    if not os.path.isdir(roles_src_path + "/" + element + "/defaults"):
        continue
    os_walk = os.walk(roles_src_path + "/" + element + "/defaults")
    for path, subdirs, files in os_walk:
        for filename in files:
            if filename.startswith("."):
                continue

            defaults_file = os.path.join(path, filename)
            defaults_dir = roles_doc_path + "_" + element

            yaml2rst.convert_file(
                defaults_file,
                roles_doc_path + "_" + element + ".rst",
                strip_regex=r"\s*(:?\[{3}|\]{3})\d?$",
                yaml_strip_regex=r"^\s{66,67}#\s\]{3}\d?$",
            )
            print("Converted {0}".format(defaults_dir))
