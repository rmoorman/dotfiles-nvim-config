
```
$ REPO_PATH=$(pwd) # path to this repository on disk
$ NVIM_APPNAME=nvim-gepiel # unique id for `~/.config/` directory

$ # link the config
$ ln -s "$REPO_PATH" "$HOME/.config/$NVIM_APPNAME"

$ # run nvim with config
$ export NVIM_APPNAME
$ vim
```
