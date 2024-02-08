```bash
$ REPO_PATH=$(pwd) # path to this repository on disk
$ NVIM_APPNAME=nvim-gepiel # unique id for `~/.config/` directory

$ # link the config
$ ln -s "$REPO_PATH" "$HOME/.config/$NVIM_APPNAME"

$ # when using `direnv`, write to `.env` file
$ echo NVIM_APPNAME=$NVIM_APPNAME > .env

$ # not using `direnv`? set the `NVIM_APPNAME` environment variable manually
$ export NVIM_APPNAME

$ # running vim should now pick up the custom config
$ vim
```
