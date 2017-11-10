#!/bin/sh
rename 's/ /_/g' *
zipDirs=$(ls -F | grep "/$")
for dir in $zipDirs
do
  zip -r "$dir".zip "$dir"
done
