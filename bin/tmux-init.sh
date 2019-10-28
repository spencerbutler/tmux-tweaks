#!/usr/bin/env bash
# Spencer's tmux-tweaks install helper
# Spencer Butler <git@crooked.app>

declare -A repos
giturl='https://github.com'
repos[spencerbutler/tmux-tweaks]="$HOME/tmux-tweaks"
repos[tmux-plugins/tpm]="$HOME/.tmux/plugins/tpm"

have_tmux() {
    command -v tmux 1>/dev/null
}

have_git() {
    command -v git 1>/dev/null
}

get_linux_ver() {
    if [ -f /etc/os-release ]; then
        linux_name=$(grep '^ID=' /etc/os-release | tr -d '"' | cut -d '=' -f 2)
        linux_maj=$(grep '^VERSION_ID=' /etc/os-release | tr -d '"' | cut -d '=' -f 2)
    else
        linux_name=Linux
        linux_maj=unknown
    fi
}

install_tmux() {
  echo "You don't have the tmux, installing."
  if [[ $linux_name == centos  ]]; then
    if [[ $linux_maj -lt 8 ]]; then
      echo "CentOS $linux_maj is old and comes with tmux 1.8"
      echo "You should install the IUS repo"
      echo "SHELL$: sudo yum install https://repo.ius.io/ius-release-el$linux_maj.rpm"
      echo "SHELL$: sudo yum install tmux2"
      echo 
      echo "Installing the tmux for your release."
      echo "Some stuff is not going to work."
      sudo yum install tmux || { echo "I couldn't install tmux"; exit; }
    else
      sudo yum install tmux || { echo "I couldn't install tmux"; exit; }
    fi

  elif [[ $linux_name == bian$ ]]; then
    sudo apt install tmux || { echo "I couldn't install tmux"; exit; }

  elif [[ $osname == fbsd ]]; then
    sudo pkg install tmux || { echo "I couldn't install tmux"; exit; }

  elif [[ $osname == obsd ]]; then
    echo "tmux is in OpenBSD base, not sure what's going on here."
    exit 1

  else
    echo "Use your package managing skills to install tmux."
    exit
  fi
  main
}

install_git() {
  echo "You have no git! Let's try and install it."
  if [[ $linux_name == centos ]]; then
    sudo yum install git || { echo "I tried..."; exit; }

  elif [[ $linux_name =~ bian$ ]]; then
    sudo apt install git || { echo "I tried..."; exit; }

  elif [[ $osname == fbsd ]]; then
    sudo pkg install git || { echo "I tried..."; exit; }

  elif [[ $osname == obsd ]]; then
    pkginfo=$(sudo pkg_info -Q git)
    if [ -z $pkginfo ]; then
      echo "I can't find git in your PKG_PATH. Let's try ftp.openbsd.org"
      echo "exporting PKG_PATH=$PKG_PATH:http://ftp.openbsd.org/pub/OpenBSD/%c/packages/%a/"
      export PKG_PATH=$PKG_PATH:http://ftp.openbsd.org/pub/OpenBSD/%c/packages/%a/ 
      sudo pkg_add git
      if command -v git 1>/dev/null; then
        echo "Git installed. Now let's get tmux working."
      else
        echo "You'll need to install git to proceed"; exit
      fi
    fi
  fi
  echo "Now you have the gits!!"
  main
}

have_dirs() {
    [ -d ${repos[$1]} ]
}

get_gits() {
    git clone ${giturl}/${1}.git ${repos[$1]} || { echo Could not get ${giturl}/${1}.git; }
}

main() {
  if ! have_tmux; then
    install_tmux
  elif ! have_git; then
    install_git
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
        echo "You alread have a $HOME/.tmux.conf! What to do, Yo?"
    fi

    echo -e "\nYou are ready to tmux shit up."
  else
    echo "We already tried to install git and it didn't work out. Please fix something."
  fi
}

case $(uname -s) in
  Linux  ) osname=linux get_linux_ver ;;
  FreeBSD) osname=fbsd ;;
  OpenBSD) osname=obsd ;;
  *      ) { echo "So sorry, $(uname -s) not supported."; exit; }
esac

main
