#!/bin/bash

requireInput=0

inputReturn=""
# some function go get input.
function getInput() {
    # we want to do some output in this function, so use this global
    # for the value
    inputReturn=""
    # first argument is the name of the value we are getting.
    # the rest are the acceptable values for the variable.
    # if anything is acceptable, pass no options
    variable=$1
    shift
    
    validInput=0
    while [ "$validInput" == 0 ] ; do
        # basically \e[<color code> stuff in color \e[0m no more color
        echo -e "\e[32mEnter a value for $variable:\e[0m"
        read -re choice
        if [ $# != 0 ] ; then
            for opt in "$@" ; do
                if [ "$choice" == "$opt" ] ; then
                   echo "$choice"
                   validInput=1
                fi
            done
        else
            validInput=1
        fi
    done
    inputReturn="$choice"
}

function yes_or_no {
    if [ "$requireInput" = 1 ] ; then
        return 0
    fi
    while true; do
        #read -rp "$* [y/n] " yn
        echo -e "\e[32m$*\e[0m"
        read -rp "[y/n] " yn
        case $yn in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
        esac
        echo no result
    done
}

getInput go_version
goVersion="$inputReturn"
echo using "$goVersion"

yes_or_no confirm before all changes \(recommended, or at least, check afterwards\)?
requireInput=$?

yes_or_no include README.md? \(platform has a lot of README.md\'s that will match the pattern\)
includeReadme=$?

# Escape the version for our sed expressions
expGoVersion=$(echo "$goVersion" | sed "s/\./\\\./g")
goModVersion=$(echo "$goVersion" | sed -E s/\([[:digit:]]\+\.[[:digit:]]\+\)\..*/\\1/g)
expGoModVersion=$(echo "$goModVersion" | sed "s/\./\\\./g")

function replaceVersion() {
    candidate=$1
    destVersion=$2

    sed -Ei s/\(GO_VERSION[[:space:]]*=?[[:space:]]*\)1\.[[:digit:]]\+\.[[:digit:]]\+$/\\1"$destVersion"/g "$candidate"
}

# We use awk and sed, which can have more similar syntax than I'm using here. But,
# once you get them working, you don't want to mess around with them. Using find is not so
# good this way, but as long as these files don't have spaces, we should be okay.
for candidate in `find . -name README.md -o -name go.mod -o -name \*.sh -o -name Dockerfile\* -o -path ./.github/workflows/\*yml`; do
    # possible expressions
    # yml: go-version: 1.xx.xx
    # Dockerfile FROM: golang:1.14.4, GO_VERSION=1.19.3 GATEWAY_GO_VERSION=1.19.3
    # When we download go, we will use a variable, so, in Docker or a .sh:
    # GO_VERSION= or GATEWAY_GO_VERSION=, so, basically, look for GO_VERSION=.
    # 
    echo checking "$candidate"
    case "$candidate" in
        *.github/*yml*)
            res=$(awk '/go-version:\s+1\.[0-9]+\.[0-9]+/' "$candidate" | xargs)
            if [ "$res" != "" ] ; then
                yes_or_no found "$res" in "$candidate". Replace with "$goVersion"
                yesno=$?
                if [ $yesno = 0 ] ; then
                    sed -Ei s/\(go-version:[[:space:]]\+\)1\.[[:digit:]]\+\.[[:digit:]]\+/\\1"$expGoVersion"/g "$candidate"
                fi
            fi
            ;;
        *Dockerfile*)
            #echo testing Dockerfile $candidate
            # test for the FROM
            resFrom=$(awk '/^FROM.*golang1\.[0-9]+\.[0-9]+/' "$candidate" | xargs)
            resVersion=$(awk '/GO_VERSION\s*=?\s*1\.[0-9]+\.[0-9]+/' "$candidate" | xargs)

            if [ "$resFrom" != "" ] ; then
                yes_or_no found "$resFrom" in "$candidate". Replace with "$goVersion"
                yesno=$?
                if [ $yesno = 0 ] ; then
                    echo said yes. replacing

                    sed -Ei s/^\(FROM.*golang:\)1\.[[:digit:]]\+\.[[:digit:]]\+\(.*\)/\\1"$expGoVersion"\\2/g "$candidate"
                fi            
            elif [ "$resVersion" != "" ] ; then
                yes_or_no found "$resVersion" in "$candidate". Replace with "$goVersion"
                yesno=$?
                if [ $yesno = 0 ] ; then
                    replaceVersion "$candidate" "$expGoVersion"
                fi
            fi
                ;;
        *sh)
            res=$(awk '/GO_VERSION=go1\.[0-9]+\.[0-9]+/' "$candidate" | xargs)
            if [ "$res" != "" ] ; then
                yes_or_no found "$res" in "$candidate". Replace with "$goVersion"
                yesno=$?
                if [ $yesno = 0 ] ; then
                    replaceVersion "$candidate" "$expGoVersion"
                fi
            fi
            ;;
        *go.mod*)
            res=$(awk '/go\s+1\.[0-9]+/' "$candidate" | xargs)
            if [ "$res" != "" ] ; then
                yes_or_no found "$res" in "$candidate". Replace with "$goModVersion"
                yesno=$?
                if [ $yesno = 0 ] ; then
                    sed -Ei s/^\(go[[:space:]]+\)1\.[[:digit:]]\+/\\1"$expGoModVersion"/g "$candidate"
                fi
            fi
            ;;
        *README.md)
            if [ "$includeReadme" = 1 ] ; then
                continue
            fi
            res=$(awk '/1\.[0-9]+\.[0-9]+/' "$candidate" | xargs)
            if [ "$res" != "" ] ; then
                yes_or_no found "$res" in "$candidate". Replace with "$goVersion"
                yesno=$?
                if [ $yesno = 0 ] ; then
                    sed -Ei s/1\\.[[:digit:]]\+\\.[[:digit:]]\+/"$expGoVersion"/g "$candidate"
                fi
            fi
            ;;
        *)
            echo unknown "$candidate"
            ;;
    esac
done

