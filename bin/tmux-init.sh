#!/usr/bin/env bash
# Initialize the tmuxeses
# Spencer Butler <spencerb@honeycomb.net>

giturl='https://github.com'
declare -A repos
repos[spencerbutler/tmux-tweaks]="$HOME/tmux-tweaks"
repos[tmux-plugins/tpm]="$HOME/.tmux/plugins/tpm"

have_tmux() {
    which tmux /dev/null 2&>1
}

have_git() {
    command -v git /dev/null 2&>1
}

have_dirs() {
    [ -d ${repos[$1]} ]
}

get_gits() {
    git clone ${giturl}/${1}.git ${repos[$1]} || { echo Could not get ${giturl}/${1}.git; }
}

linux() {
  if [ ! have_tmux ]; then
      echo "You don't have the tmux, installing."
      if [ command -v rpm ]; then
        centmaj="$(rpm -E %{rhel})"
        if [[ $centmaj -lt 8 ]]; then
          echo "CentOS $centmaj is old and comes with tmux 1.8"
          echo "You should install the IUS repo"
          echo "SHELL$: sudo yum install https://repo.ius.io/ius-release-el${centmaj}.rpm"
          echo "SHELL$: sudo yum install tmux2"
          echo 
          echo "Installing the tmux for your release."
          echo "Some stuff is not going to work."
          sudo yum install tmux || { echo "I couldn't install tmux"; exit; }
        fi
      else
        echo "Use your package manager to install tmux."
      fi
  else
      if [ $(uname -s) == OpenBSD ]; then
          true
      else 
        tmuxver=$(tmux -V)
        centmaj="$(rpm -E %{rhel})"
        if [[ ${tmuxver#* } =~ ^1 ]]; then
          echo "Your tmux version \"$tmuxver\" is old, please upgrade"
          echo "You should install the IUS repo"
          echo "SHELL$: sudo yum install https://repo.ius.io/ius-release-el${centmaj}.rpm"
          echo "SHELL$: sudo remove tmux"
          echo "SHELL$: sudo yum install tmux2"
        fi
      fi

  fi

  if have_git; then
    for repo in ${!repos[@]}; do
      if $(have_dirs $repo); then
          echo "We have a $repo directory."
          true
      else
          echo "Installing $repo into ${repos[$repo]}"
          get_gits $repo
      fi
    done

    cd ${repos[spencerbutler/tmux-tweaks]} && \
        git checkout away && git pull || echo "WTF, couldn't cd to ${repos[spencerbutler/tmux-tweaks]}" 
    cd $HOME
    if [ ! -f $HOME/.tmux.conf ]; then
        ln -s ${repos[spencerbutler/tmux-tweaks]}/conf/tmux.conf .tmux.conf
    else
        echo "You alread have a $HOME/.tmux.conf, what to do, yo?"
    fi

    echo You are ready to tmux shit up.
  else
     echo "You have no git!"
     sudo yum install git || { echo "I tried..."; exit; }
     echo "Now you have the gits!!"
     linux
  fi
}

fbsd() {
  if [ ! have_tmux ]; then
      echo "You don't have the tmux, installing."
      sudo pkg add tmux || { echo "I couldn't install tmux"; exit; }
  fi

  if have_git; then
    linux
  else
    echo "You have no git!"
    sudo pkg add git || { echo "I tried..."; exit; }
    echo "Now you have the gits!!"
    linux
  fi
}

obsd() {
  # tmux is a part of OpenBSD base
  if have_git; then
      linux
  else
    echo "You have no git!"
    export PKG_PATH=$PKG_PATH:http://ftp.openbsd.org/pub/OpenBSD/%c/packages/%a/ 
    sudo pkg_add git
    linux
  fi
}

case $(uname -s) in
  Linux  ) linux;;
  FreeBSD) fbsd;;
  OpenBSD) obsd;;
  *      ) { echo $(uname -s) not supported.; exit; }
esac

