#!/bin/bash

if ! command -v genisoimage > /dev/null; then
  mkhybrid_path=$(command -v mkhybrid)
  if [ -n "$mkhybrid_path" ]; then
     sudo ln -s "$mkhybrid_path" /usr/local/bin/genisoimage
  fi
fi

cloud-localds seed.iso user-data
chmod uo+rx seed.iso
