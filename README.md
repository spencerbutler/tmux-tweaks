# tmux-tweaks
## Prerequisites
### Bash Version 4.2 (or higher)
```
[ $BASH_VERSINFO -ge 5 ] || { [ $BASH_VERSINFO -eq 4 ] && [ ${BASH_VERSINFO[1]} -ge 2 ]; } && 
echo $BASH_VERSION is OK. || echo $BASH_VERSION is too old.
```
### git (installer tries to install from packages if available)
### tmux 
The install script will try and install tmux if it's not available. Tmux before 1.9 will not understand a lot of options used
in this plugin. It is highly recommended to use the most recent version of tmux available.

## Install 
This assumes you don't already have a $HOME/.tmux.conf. If you do, you'll need to move it out of the way to use this plugin.
___
### Install Script
The [bin/tmux-init.sh](../master/bin/tmux-init.sh) helper script has been tested to install (if missing)
git and tmux, this [repo](../../), the [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) along with the awesome plugins [Resurrect](https://github.com/tmux-plugins/tmux-resurrect) and [Continuum](https://github.com/tmux-plugins/tmux-continuum) 
-- successfully on Debian, Raspbian, FreeBSD, OpenBSD and CentOS 7.  

#### Linux
`wget -qO- https://raw.githubusercontent.com/spencerbutler/tmux-tweaks/master/bin/tmux-init.sh | bash -s`  
or  
`curl -so- https://raw.githubusercontent.com/spencerbutler/tmux-tweaks/master/bin/tmux-init.sh | bash -s`

#### OpenBSD
`ftp -o- https://raw.githubusercontent.com/spencerbutler/tmux-tweaks/master/bin/tmux-init.sh | bash -s`
#### FreeBSD
`fetch -o- https://raw.githubusercontent.com/spencerbutler/tmux-tweaks/master/bin/tmux-init.sh | bash -s`

---
### Git Clone
  
```
git clone https://github.com/spencerbutler/tmux-tweaks.git $HOME/tmux-tweaks
cd $HOME
ln -s tmux-tweaks/conf/tmux.conf .tmux.conf
tmux
```

## Config
The [conf/tmux.conf](../master/conf/tmux.conf) config file should work out of the box.

#### User Config Options
Register the plugin with the name spencer.  
The value of the `@spencer` option should be a tmux source-able file with the the extension ".theme". The `default.theme` attempts to reset things to factory
settings. This is no where close ATM.

`set -g @spencer 'spencer'`

Choose a _colour_ scheme.
Colours (tmux uses colour{0..255), don't use **color{0..255)** in your config!) 
are in development and have the extension ".colours".

`set -g @spencer_colours 'baby_blues'`

Initialize the plugin. (This should be at the bottom[ish] of your tmux.conf.)

`run-shell -b '~/tmux-tweaks/spencer.tmux'`

## Support
### Issues
This project is in active development, so use with caution. Once it becomes stable, I'll keep a stable release and include
updated information here. Feel free to open an issue if something needs fixing. 

No License. 
