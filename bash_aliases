#!/bin/bash aliases

alias kate='quiet -l -p kate'
alias kdiff='quiet -l -p kompare'
alias dolphin='quiet -l -p dolphin'
alias kdv='quiet -l -p kdevelop'
alias kdevelop='quiet -l -p kdevelop'
alias okular='quiet -l -p okular'
alias okteta='quiet -l -p okteta'
alias kcachegrind='quiet -l -p kcachegrind'
alias massif-visualizer='quiet -l -p massif-visualizer'
alias krusader='quiet -l -p krusader'
alias gitg='quiet -l -p gitg'
alias qtcreator='quiet -l -p qtcreator'
alias krdc='quiet -l -p krdc'
alias sane='stty sane;setterm -linewrap on'
alias liteide='quiet liteide'
alias arduino='quiet arduino'

alias ssh-git='keychain /home/mark/.ssh/id_rsa.github'
alias dcabb='keychain /home/mark/.ssh/bbucket_rsa'

alias gitk='quiet -l -p gitk --all'
alias qgit='quiet -l -p qgit4'
alias git-dag='quiet -l -p git-dag'
alias git-cola='quiet -l -p git-dag'
alias s='git status'
alias s.='git status .'

alias df='df -h'
alias du='du -h'
alias free='free -m'
alias lping='ping -c3 -W1'

alias fpn='find . -name'

alias hd='hexdump -C'

alias apg='apg -M SNCL'

#finicky. add /usr/lib64 to LD_LIBRARY_PATH so system's libgdiplus is found/used first.
alias logv='ININ_TRACING=/home/mark/data/inin_tracing GTK2_RC_FILES=/usr/share/themes/Adwaita/gtk-2.0/gtkrc LD_LIBRARY_PATH=/usr/lib64/:/home/mark/data/builds/core_main_systest/pub/gen/bin/l64:/home/mark/data/builds/system_main_systest/pub/gen/bin/l64/:/home/mark/data/builds/ininbuild_main_systest/pub/gen/bin/l64/ mono $(ls --color=never /home/mark/data/builds/core_main_systest/pub/gen/bin/l64/ininlogviewer-l64d-*.exe |tail -n1) 2>&1 >/dev/null &'

alias ls='ls -h --color'
alias la='ls -a'
alias ll='ls -l'
alias lls='ll'
alias atree='tree | sed "s/├/\+/g; s/─/-/g; s/└/\\\/g;"'

function big() {
  d=$1
  if [[ "$d" == "" ]]; then
    d=$PWD
  fi
  du -sh $d/* | sort -rh | head -n5
}

alias gnr='grep -Inr --color'
alias grep='grep -I --color'
alias cgrep='grep --color=force'
alias igrep='grep -iI'
alias xgrep='grep --exclude-dir=build/ -nrI'
alias nocomments='grep -ve "^#" -e ^$'

alias diff='diff -uw'
alias cdiff='colordiff -uw'

alias ip='ip -c'
alias ip4='ip -4 addr'
alias which='alias | which -i'

alias irss='LANG=en_US.UTF-8 /usr/bin/mosh --server="LANG=en_US.UTF-8 mosh-server" -- dockstar sh -c "tmux attach-session -t irssi || tmux new-session -s irssi irssi"'

alias ark='quiet -l -p ark'
alias icons='ipmi-console.sh'

alias nano='nano -zw'

alias addalias='kate ~/.bash_aliases'
alias upalias='. ~/.bash_aliases'

alias ion='cd ~/data; . ./ion_devenv'

function RemoteCmd() {
  konsoleprofile colors=linux-remote
  sleep .05
  $@
  sleep .05
  konsoleprofile colors=Linux
}


function SolarCmd() {
  konsoleprofile colors=Solarized
  sleep .05
  $@
  sleep .05
  konsoleprofile colors=Linux
}

function TitledCmd() {
  case "$1" in
  VI)
    #squared inverted V, bold I - corp vpn
    konsoleprofile tabtitle=$'\xF0\x9F\x86\x85 \xf0\x9d\x97\x9c'
    ;;
  VD)
    #squared inverted V, bold D - dca vpn
    konsoleprofile tabtitle=$'\xF0\x9F\x86\x85 \xf0\x9d\x97\x97'
    ;;
  VT)
    #squared inverted V, bold T - tca vpn
    konsoleprofile tabtitle=$'\xF0\x9F\x86\x85 \xf0\x9d\x97\xa7'
    ;;
  VP)
    #squared inverted V, bold P - prod vpn
    konsoleprofile tabtitle=$'\xF0\x9F\x86\x85 \xf0\x9d\x97\xa3'
    ;;
  SD)
    #circled inverted S, bold D - non-prod ssh
    konsoleprofile tabtitle=$'\xF0\x9F\x85\xA2 \xf0\x9d\x97\x97'
    ;;
  MW)
    #circled inverted M, bold W - mosh work
    konsoleprofile tabtitle=$'\xF0\x9F\x85\x9C \xf0\x9d\x97\xaa'
    ;;
  S)
    #circled inverted S         - other ssh
    konsoleprofile tabtitle=$'\xF0\x9F\x85\xA2' # \xf0\x9d\x97\x9b'
    ;;
  SP)
    #circled inverted S, bold P - prod ssh (bastion +)
    konsoleprofile tabtitle=$'\xF0\x9F\x85\xA2 \xf0\x9d\x97\xa3'
    ;;
  vm)
    #bold V, bold M - vagrant vm
    konsoleprofile tabtitle=$'[\xf0\x9d\x97\xa9\xf0\x9d\x97\xa0]'
    ;;
    #currently unused \xe2\x92\xBE - circled I
  *)
    konsoleprofile tabtitle="%d : %n"
    ;;
  esac
  shift
  $@
  sleep .05
  konsoleprofile tabtitle="%d : %n"
}

function ssh() {
  konsoleprofile colors=linux-remote
  /usr/bin/ssh $@
  konsoleprofile colors=Linux
}

function mosh() {
  konsoleprofile colors=linux-remote
  /usr/bin/mosh $@
  konsoleprofile colors=Linux
}
alias wah='RemoteCmd TitledCmd MW mosh -p 5061 -- mark-work tmux new -A -D -swah'

alias corp='SolarCmd TitledCmd VI CVPN'
alias dvpn='SolarCmd TitledCmd VD OVPN d'
alias tvpn='SolarCmd TitledCmd VT OVPN t'
alias uuid="uuidgen | tr -d '-' | tr 'a-z' 'A-Z'"

alias amnesshia='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'


alias vssh='EDGE_VERSION=dummyv RemoteCmd TitledCmd vm vagrant ssh'
alias vreboot="EDGE_VERSION=dummyv vagrant ssh -c 'sudo shutdown -r now'; sleep 40; vssh"
alias vrp='TitledCmd vm vagrant reload --provision'

alias vip='aws ec2 describe-instances --instance-id=$(cat .vagrant/machines/default/aws/id) | jq -r  .Reservations[].Instances[].PrivateIpAddress'

#shows sizes of dirs with du
sum() {
  if [ "$#" -gt "0" ]; then
    _pfx="$1/"
  else
    _pfx=""
  fi
  du -sh $_pfx* | sort -h | tail
  unset _pfx
}

#sourcesum - like sum, but shows lines in files with wc
ss() {
  if [ "$#" -gt "0" ]; then
    _pfx="$1/"
  else
    _pfx=""
  fi
  wc -l $_pfx* | sort -h
  unset _pfx
}

# JSON pretty print with jq
jpp() {
  [[ "$1" == "" ]] && echo "missing arg" && return
  _pp=$(mktemp)
  jq . <$1 >$_pp && mv $_pp $1 || rm -f $_pp
  unset _pp
}

# print line $1 of file $2
l() {
  head -n$1 $2 | tail -n1
}

#add new group to your groups, without logout
#exec sg <new group name> newgrp `id -gn`

# machine-specific aliases, if applicable
if [[ -f ~/.other_aliases ]]; then
  source ~/.other_aliases
fi
