if [ -f "/google/devshell/bashrc.google" ]; then
  source "/google/devshell/bashrc.google"
fi

if [ -n "$PS1" ]; then
  # and if zsh is installed
  if command -v zsh >/dev/null 2>&1; then
    # and if the current shell is not zsh
    if [ "$SHELL" != "$(command -v zsh)" ]; then
      export SHELL="$(command -v zsh)"
      exec zsh -l
    fi
  fi
fi
