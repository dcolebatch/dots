#!/bin/bash

# Update and install base dependencies
sudo apt-get update && sudo apt-get install -y \
  powerline fonts-powerline \
  zsh tmux curl git build-essential \
  libssl-dev libffi-dev python3-pip openjdk-17-jdk neovim

# Clone your dotfiles
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
  git clone https://github.com/dcolebatch/dotfiles.git "$DOTFILES_DIR"
fi

# Symlink .zshrc from dotfiles
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Install Node.js (Latest via nvm)
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  . "$NVM_DIR/nvm.sh"
fi
nvm install node
nvm use node

# Install Python (Latest via pyenv)
if [ ! -d "$HOME/.pyenv" ]; then
  curl https://pyenv.run | bash
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
fi
pyenv install -s $(pyenv install --list | grep -E "^[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+$" | tail -1)
pyenv global $(pyenv versions --bare --skip-aliases | head -1)

# Install Ruby (Latest via rbenv)
if [ ! -d "$HOME/.rbenv" ]; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  cd ~/.rbenv && src/configure && make -C src
  cd ~
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
fi
rbenv install -s $(rbenv install --list | grep -E "^[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+$" | tail -1)
rbenv global $(rbenv versions --bare | head -1)

# Install Go (Latest via official installer)
if ! command -v go &> /dev/null; then
  curl -LO https://golang.org/dl/go$(curl -s https://golang.org/VERSION?m=text | head -1).linux-amd64.tar.gz
  sudo tar -C /usr/local -xzf go*.linux-amd64.tar.gz
  rm -f go*.linux-amd64.tar.gz
fi
export PATH="/usr/local/go/bin:$PATH"

# Install Rust (Latest via rustup)
if ! command -v rustc &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Set default shell to zsh
chsh -s $(which zsh)

# Install Powerline status
if ! pip3 show powerline-status &> /dev/null; then
  pip3 install powerline-status
fi

# Install Docker Compose
if ! command -v docker-compose &> /dev/null; then
  sudo curl -L "https://github.com/docker/compose/releases/download/$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d 'v' -f2 | cut -d '"' -f1)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

echo "Setup complete. Restart your terminal or reload zsh."
