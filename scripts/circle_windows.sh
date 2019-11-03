#/bin/sh

l0=
l1=
l2=
l3=
l4=
l5= 
l6= 
l7= 
l8= 
l9= 
l10= 
r0=
r1=
r2=
r3=
r4=
r5=
r6=
r7=
r8=
r9=
r10=

windowid="$(tmux display -p '#I')"
paneid="$(tmux display -p '#P')"

case $windowid in
  0) wid=$l0 ;;
  1) wid=$l1 ;;
  2) wid=$l2 ;;
  3) wid=$l3 ;;
  4) wid=$l4 ;;
  5) wid=$l5 ;;
  *) pid="OK" ;;
esac
case $paneid in
  0) pid=$r0 ;;
  1) pid=$r1 ;;
  2) pid=$r2 ;;
  3) pid=$r3 ;;
  4) pid=$r4 ;;
  5) pid=$r5 ;;
  *) pid="OK" ;;
esac

tmux set-env -g zoom_icons "$wid,$pid"
tmux set -g "@tweaks_circle" "$wid"
echo "$wid  $pid"

