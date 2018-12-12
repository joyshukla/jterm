#!/usr/bin/env bash

# example command
# vim $(cat /tmp/$TMUX_PANE-stack/item.1)

if [ -e /tmp/$TMUX_PANE-stack/item.$1 ]
then
    filename=$(cat /tmp/$TMUX_PANE-stack/item.$1)

    # if filename has + i.e. line number
    if [[ $filename == *"+"* ]] 
    then
        # adds a space between file name and the line number
        file=${filename/+/ +}
        vim $file
    else
        vim $filename
    fi
else
    echo entry $@ does not exist
fi
