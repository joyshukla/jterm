#!/usr/bin/env bash

# example command
# vim $(cat /tmp/$TMUX_PANE-stack/item.1)

function editOneFile(){
    if [ -e /tmp/$TMUX_PANE-stack/item.$@ ]
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
}

if [[ $1 == *"-"* ]]
then
    fileRange=($(echo "$1" | tr '-' '\n'))
    st=${fileRange[0]}
    en=${fileRange[1]}
   
    #echo $st
    #echo $en

    for fileNum in $(seq $st $en)
    do
        #echo $fileNum
        editOneFile $fileNum
    done
else
    editOneFile $1
fi
