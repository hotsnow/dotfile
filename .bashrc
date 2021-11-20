# Reload Library
source $HOME/.bash.basic.rc

case $OSTYPE in
  darwin*)
    source $HOME/.bash.mac.rc
    ;;
  Linux*)
    source $HOME/.bash.linux.rc
    ;;
esac

# source local file which not in git
[[ -f ~/.bash.local.rc ]] && source ~/.bash.local.rc
