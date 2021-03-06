#!/usr/bin/env bash

# return if no arguments supplied
if [ $# -eq 0 ]
then
    echo "No arguments supplied"
    exit -1
fi

OS_ID=$(uname)

#echo "$OS_ID"
. stack-operations

function createSearchString(){
	# function to create search string from multiple arguments
	# it search for both the arguments i.e. OR
	
	flag=0
	for arg in "$@"
	do
	    if [ "$flag" -eq 0 ]
        then
            searchStr=$arg
            flag=1
        else
            if [[ "$OS_ID" == 'Linux' ]]           # tested on ubuntu
            then
                searchStr="\($searchStr\|$arg\)"
            elif [[ "$OS_ID" == 'Darwin' ]]        # tested on macos
            then
                searchStr="$searchStr\|$arg"
            fi
    fi
	done
    echo $searchStr
}

function createColorGrepString(){
	# function to create color grep string from multiple arguments
	# it search for both the arguments i.e. OR
	
	flag=0
	for arg in "$@"
	do
	    if [ "$flag" -eq 0 ]
        then
            colorGrepStr=$arg
            flag=1
        else
            colorGrepStr="$colorGrepStr\|$arg"
    fi
	done
    echo $colorGrepStr
}

function runCommand(){
    # function to run command
    searchStr=$@
    cmd="grep -InirE $searchStr ."

    # to echo command to stderr, uncomment below line
    #echo $cmd >&2
    # with eval for find, dont know reason for this, but only this works
    eval $cmd
}

# delete previous stack and create new directory
initStackDir

# create search string from command line arguments
searchStr=$(createSearchString $@)

# create color grep string
colorGrepStr=$(createColorGrepString $@)

# run the command
out=$(runCommand $searchStr)

# process the output to keep only first two columns
# and replace : with + for line numbers
pOut=$(echo "$out" | cut -d ':' -f 1,2 | sed -e 's/:/+/')

# add entries to the stack specific for this pane
addEntriesToStack $pOut

#echo $colorGrepStr

# NOTE: grep --color does not work with multiple strings i.e. \| symbol
# so first trying to print with color, if it fails, print normally

echo "$out" | nl -w 3 | grep --color=always -i -E $colorGrepStr | less -EXR

if [ $? -ne 0 ]
then
    echo "$out" | nl -w 3 | less -EX
fi

