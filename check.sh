#!/usr/bin/env bash

exitfn () {
    trap SIGINT                                   # Restore signal handling for SIGINT
    rm -rf $path/000_$var
    exit                                          # then exit script.
}

trap "exitfn" INT                                 # Set up SIGINT trap to call function.

path="/mnt"                                       # define the path to monitor for RW or RO
freq="1"                                          # do the check every 1sec

while :
do
  var=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)    # create random string of 8chars to differentiate checks
  if echo "$var" > $path/000_$var; then           # if the script is able to write:
    echo "read-write "$var                        # notify write ok
  else
    echo "READ-ONLY! "$var                        # notify not ok
  fi
sleep $freq                                       # do the check every n sec    
rm -rf $path/000_$var                             # remove the file
done

trap SIGINT                                       # Restore signal handling to previous before exit.
