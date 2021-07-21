#! /bin/sh

if [ $# -eq 0 ] ; then
    echo "Please pass file name and output folder and url"
    exit 0
fi

FILE=$1
OUTPUT=$2
SITE=$3

while read line
do
  URL="$SITE/${line}.zip"
  PATTERN=" "
  STR="%20"
  URL=${URL//$PATTERN/$STR}
  curl $URL > "$OUTPUT/${line}.zip"
done < $FILE
