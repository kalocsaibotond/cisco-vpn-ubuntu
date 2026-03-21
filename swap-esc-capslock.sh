#!/bin/sh


root_path=$1
if [ -z "$(findmnt "$root_path")" ]; then
  echo "Invalid root path name! Cancelling swap."
  return 1
fi

sudo mkdir -p "$root_path/etc/default"

if ! grep -q "XKBOPTIONS=" "$root_path/etc/default/keyboard"; then

    echo 'set number
$ append

XKBOPTIONS="caps:swapescape"
.
xit' | sudo ex "$root_path/etc/default/keyboard"

elif ! grep -q "caps:swapescape" "$root_path/etc/default/keyboard"; then

    echo 'set number
/XKBOPTIONS=/
. s/"\\(.*\\)"/"\\1,caps:swapescape"/g
xit' | sudo ex "$root_path/etc/default/keyboard"

fi
