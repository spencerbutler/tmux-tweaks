# tmux-tweaks
## Prerequisites
### Bash Version 4.2 (or higher)
```
[ $BASH_VERSINFO -ge 5 ] || { [ $BASH_VERSINFO -eq 4 ] && [ ${BASH_VERSINFO[1]} -ge 2 ]; } && 
echo $BASH_VERSION is OK. || echo $BASH_VERSION is too old.
```
### git 
The installer tries to install with your system's package manager.
### tmux 
The installer tries to install with your system's package manager.  
Tmux before 1.9 will not understand a lot of options used in this plugin. It is highly recommended to use the most recent version of tmux available.

## Install Methods
### Install Script
The [scripts/tmux-init.sh](scripts/tmux-init.sh) helper script has been tested to install (if missing)
git and tmux, this [repo](../../), the [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) along with the awesome plugins [Resurrect](https://github.com/tmux-plugins/tmux-resurrect) and [Continuum](https://github.com/tmux-plugins/tmux-continuum) 
-- successfully on Debian, Raspbian, FreeBSD, OpenBSD and CentOS 7. (You don't need the `Git Clone` step if you use the script.)

#### Linux
`wget -qO- https://raw.githubusercontent.com/spencerbutler/tmux-tweaks/master/scripts/tmux-init.sh | bash -s`  
or  
`curl -so- https://raw.githubusercontent.com/spencerbutler/tmux-tweaks/master/scripts/tmux-init.sh | bash -s`

#### OpenBSD
`ftp -o- https://raw.githubusercontent.com/spencerbutler/tmux-tweaks/master/scripts/tmux-init.sh | bash -s`
#### FreeBSD
`fetch -o- https://raw.githubusercontent.com/spencerbutler/tmux-tweaks/master/scripts/tmux-init.sh | bash -s`

### [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)
See [User Config Options](#user-config-options) for more options.
```
set -g @plugin 'spencerbutler/tmux-tweaks'
```
### Git Clone
```
git clone https://github.com/spencerbutler/tmux-tweaks.git $HOME/.tmux/plugins/tmux-tweaks
```
Update the **end** of your $HOME/.tmux.conf
```
run-shell -b $HOME/.tmux/plugins/tmux-tweaks/tmux-tweaks.tmux
```

## User Config Options
### [conf/tmux.conf](conf/tmux.conf) Available for reference.
### Defaults
```
set -g @plugin 'spencerbutler/tmux-tweaks'
set -g @tweaks_theme 'tmux-tweaks'
set -g @tweaks_theme_colours 'tmux-tweaks'
set -g @tweaks_theme_icons 'tmux-tweaks'
```
The first setting is for [TPM](https://github.com/tmux-plugins/tpm).  
The `@tweaks_` settings follow the directory structure of [tmux-tweaks](../../).
- `@tweaks_theme 'THEME-NAME'` live in [themes](/themes)
- `@tweaks_theme_colours 'COLOUR-NAME'` live in [themes/colours](/themes/colours)
- `@tweaks_theme_icons` 'ICON-NAME'` live in [themes/icons](/themes/icons)  

You can set the `@tweaks_` options to any value (minus the file extension) that exist in the directories. 

## Features *experimental*
### Export Theme
`prefix e` will prompt you to name your theme.  
`prefix E` will write your theme to $HOME/..tmux/tmux-tweaks/local/export/themes/THEME-NAME.theme  
`prefix C-e` will load THEME-NAME (defaults to the name of the THEME-NAME you just created.)  
### Reset to Defaults
`tmux set -g @tweaks_theme 'factory-settings'` will reset all options and variables to their default states.  

## Support
### Issues
This project is in active development, so use with caution. Once it becomes stable, I'll keep a stable release and include
updated information here. Feel free to open an issue if something needs fixing. 

No License. 
