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
        # pause after 5 files
        offset=$(($fileNum - $st))
        if [[ $(($offset % 5)) == 0 ]] && [[ $fileNum != $st ]] 
        then
            echo -n 'Press any key to continue and "q" to quit : '
            read -n1 ans
            if [[ $ans == 'q' ]] || [[ $ans == 'Q' ]]
            then
                echo
                echo 'exiting'
                exit -1                 
            fi
        fi
        
        #echo $fileNum

        # edit one file
        editOneFile $fileNum
    done
else
    # no range exist, opening single file
    editOneFile $1
fi
