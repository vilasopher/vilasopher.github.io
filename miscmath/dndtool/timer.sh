#!/bin/bash

OUTPUT="$(timeout 5s ./Main $1 $2 $3)"

if [ "$OUTPUT" == "" ]; then
	echo "Sorry, there was a problem with your computation.<br>Either there is some problem with your input values or you ran out of execution time.<br>To speed up the computation, try increasing the margin of error.<br>Alternatively, download the source code to run on your own computer."
else
	echo $OUTPUT
fi
