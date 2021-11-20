# The way to use this project

More detail here: [The best way to store your dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

```
# add file to local
git clone --bare <git-repo-url> $HOME/.cfg

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# backup the config file
mkdir -p .config-backup && \
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
    xargs -I{} mv {} .config-backup/{}

# checkout and done
config checkout
```

