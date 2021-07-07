#! /bin/sh

if [ $# -eq 0 ] ; then
    echo 'Please pass folder name'
    exit 0
fi

FOLDER=$1
find $FOLDER -type f -name "*.zip" -print0 | xargs -0 shuf -zen1 | xargs -0 mv -vt reviewing



