#!/bin/bash

# loop over each user directory, insert sambashare bookmark

for d in /vsfs01/home/* ; do
    echo "${d}"
    sed -i 's/file:\/\/\/vsfs01\/share//g' ${d}/.config/gtk-3.0/bookmarks
    echo "file:///vsfs01/share" >> ${d}/.config/gtk-3.0/bookmarks
done
