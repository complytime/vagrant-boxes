#!/usr/bin/env bash

export PYTHON_VERSION=3.9.0
export POETRY_VERSION=1.7.1


sudo dnf groupinstall "Development Tools" -y
sudo dnf install make gcc patch zlib-devel \
      bzip2 bzip2-devel readline-devel \
      sqlite sqlite-devel openssl-devel \
      tk-devel libffi-devel xz-devel \
      libuuid-devel gdbm-libs libnsl2 -y

curl -fsSL https://pyenv.run | bash

cat >> .zshrc << EOF

# The following lines were added by python install
export PYTHON_VERSION=${PYTHON_VERSION}

export PYENV_ROOT="\$HOME/.pyenv"
[[ -d \$PYENV_ROOT/bin ]] && export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init - zsh)"

pyenv shell \$PYTHON_VERSION
pyenv activate \$PYTHON_VERSION-default
# End of lines added by python install
EOF

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

pyenv update

pyenv install $PYTHON_VERSION

pyenv shell $PYTHON_VERSION
pyenv virtualenv $PYTHON_VERSION-default
pyenv activate $PYTHON_VERSION-default

pip install --no-cache-dir --upgrade pip
pip install --no-cache-dir pipx
pipx install poetry=="$POETRY_VERSION"