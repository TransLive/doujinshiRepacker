#!/bin/sh
path="$1"
if [ -d "$path/ex" ];then
  cd "$path"
else
  echo "not a path"
  exit
fi
rename 's/ /_/g' *
zipDirs=$(ls -F | grep "/$")
for dir in $zipDirs
do
  zip -r "${dir%/*}.zip" "$dir"
  rm -r "$dir"
done
cd -
