#!/usr/bin/env bash

export PYTHON_VERSION=3.8.2

curl -fsSL https://pyenv.run | bash

cat >> .zshrc << EOF

# The following lines were added by python install
export PYTHON_VERSION=${PYTHON_VERSION}

export PYENV_ROOT="\$HOME/.pyenv"
[[ -d \$PYENV_ROOT/bin ]] && export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init - zsh)"

pyenv shell \$PYTHON_VERSION
pyenv virtualenv \$PYTHON_VERSION-default
# End of lines added by python install
EOF

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

pyenv update

sudo dnf install make gcc patch zlib-devel \
      bzip2 bzip2-devel readline-devel \
      sqlite sqlite-devel openssl-devel \
      tk-devel libffi-devel xz-devel \
      libuuid-devel gdbm-libs libnsl2 -y

pyenv install $PYTHON_VERSION