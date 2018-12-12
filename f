#!/usr/bin/env bash

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
            #searchStr="\($searchStr\|$arg\)"   # ubuntu
            searchStr="($searchStr|$arg)"         # os x
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
    #cmd="find . -iregex ^.*$searchStr.*"        # ubuntu
    cmd="find -E . -iregex ^.*$searchStr.*"

    # to echo command to stderr, uncomment below line
    #echo $cmd >&2
    # without eval for find, dont know reason for this, but only this works
    $cmd
}

# delete previous stack and create new directory
initStackDir

# create search string from command line arguments
searchStr=$(createSearchString $@)

# create color grep string
colorGrepStr=$(createColorGrepString $@)

# run the command
out=$(runCommand $searchStr)

# no processing required for find since there are no line numbers

# add entries to the stack specific for this pane
addArrayToStack $out

#echo $colorGrepStr

# NOTE: grep --color does not work with multiple strings i.e. \| symbol
# so first trying to print with color, if it fails, print normally

echo "$out" | nl -w 3 | less -EX | grep --color -i -E $colorGrepStr

if [ $? -ne 0 ]
then
    echo "$out" | nl -w 3 | less -EX
fi

