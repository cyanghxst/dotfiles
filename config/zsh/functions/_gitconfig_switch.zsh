_gitconfig_switch() {
  local ubc_root="$HOME/code/ubc/cpsc-210"
  local ubc_config="$HOME/.gitconfig-ubc"
  local default_config="$HOME/.gitconfig"

  case "$PWD" in
    $ubc_root|$ubc_root/*)
      [[ $GIT_CONFIG_GLOBAL != $ubc_config ]] && export GIT_CONFIG_GLOBAL=$ubc_config
      ;;
    *)
      [[ $GIT_CONFIG_GLOBAL != $default_config ]] && export GIT_CONFIG_GLOBAL=$default_config
      ;;
  esac
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _gitconfig_switch

_gitconfig_switch
