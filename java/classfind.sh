#!/bin/bash
# This script searches for a Java class name in all JAR files it recursively finds from the given starting point
# Author: Christian Schuit
# Required: None

# Usage:
# classfind.sh <name of java class without package> <optional directory as starting point>

CLASS="$1"
IN="."
if [ -n "$2" ]; then
    IN="$2"
fi

echo ""
echo "Searching for '$CLASS' in '$IN'.."
for JAR in `find $IN -name '*.jar' | grep -v "MACOSX"`; do

 	echo "  in $JAR.."
 	jar -t -f "$JAR" | sed 's/\//./g' | grep "$CLASS" | awk -v var=$1 '{print "\n--> FOUND: " var "\n" }'
 done
