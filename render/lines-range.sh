#!/bin/bash

# echo file: $1 >&2
# echo from: $2 >&2
# echo lines $3 >&2

if [ ! $3 ] 
then 
	echo "usage $0 filename start-line num-lines" >&2
      	exit 1
fi

# echo "still alive" >&2
tail -n+$2 $1 | head -n$3

