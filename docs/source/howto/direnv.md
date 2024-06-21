# Manage venv with direnv

```{code-block}
:caption: .envrc
# Virtualenv with default
layout_python3

# Ansible environment configuration
export DIRENV_TMP_DIR="${PWD}/.direnv"
export ANSIBLE_COLLECTIONS_PATH="${DIRENV_TMP_DIR}"
export ANSIBLE_ROLES_PATH="${DIRENV_TMP_DIR}/ansible_roles:${PWD}/roles"

# Secrets environment loading, files you would typically git-ignore
DIRENV_ADDONS=".env.local .env.secrets .env.secret"
for addon in ${DIRENV_ADDONS}; do
    if [ -e "${PWD}/${addon}" ]; then
        source ${PWD}/${addon}
    fi
done
```
