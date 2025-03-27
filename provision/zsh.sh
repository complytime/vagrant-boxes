#!/usr/bin/env bash

sudo dnf install zsh -y
sudo usermod --shell $(which zsh) vagrant

cat > .zshrc << EOF

# The following lines were added by compinstall
zstyle :compinstall filename '/home/vagrant/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
EOF