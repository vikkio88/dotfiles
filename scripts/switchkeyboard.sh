#!/bin/bash
SOURCE=`gsettings get org.gnome.desktop.input-sources sources`

if [[ "$SOURCE" == *"[('xkb', 'gb')]" ]]
then
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'it')]"
else
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'gb')]"
fi