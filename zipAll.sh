#!/bin/sh
path="$1"
if [ -z $path ];then
  #echo "確定對當前目錄" $(pwd) "執行？"
  read -p "確定對當前目錄 $(pwd) 執行(y/any)？" permit
  if [[ $permit != y ]];then
    exit
  else
    path=$(pwd)
  fi
fi

if [ -d "$path" ];then
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
