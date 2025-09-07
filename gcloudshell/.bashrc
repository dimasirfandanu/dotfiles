if [ -f "/google/devshell/bashrc.google" ]; then
  source "/google/devshell/bashrc.google"
fi

if [ -n "$PS1" ]; then
  # Check for zsh and install if not found
  if ! command -v zsh >/dev/null 2>&1; then
    echo "zsh not found, installing..."
    sudo apt-get update && sudo apt-get install -y zsh
  fi

  # and if zsh is installed
  if command -v zsh >/dev/null 2>&1; then
    # and if the current shell is not zsh
    if [ "$SHELL" != "$(command -v zsh)" ]; then
      export SHELL="$(command -v zsh)"
      exec zsh -l
    fi
  fi
fi