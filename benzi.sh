#!/bin/sh
#put this script into root directory of mangas
function rarType()
{
    #type0: rar with rars in
    echo 0
    #type1: rar with folder in
    #type2: rar with jpgs in
}

function rarEx()
{
    rootPath="$1"
    rars="$2"
    d="$3"
    password=$4
    echo  $password
    return
    exit
    for r in $rars
    do
        #unrar x -p$password "$r" "$rootPath/tmp"
        #type0: rar with rars in.extract to here,add all new rars' dir into $rars
        if [ rarType==0 ];
        then
            rName=$(basename $r)
            unrar x -p"$password" "$r" "$d"
            echo ----------------------------
        fi
        #type1: rar with folder in.immediately extract to final dir
        # elif [ rarType==1 ];then

        # fi
        # #type2: rar with jpgs in
        # elif [ rarType==2 ];then
        #     mkdir "$rootPath/ex/$d/$r"
        #     unrar x -p"$1" "$rootPath/ex/$d/$r"
        # fi
    done
}


# TODO:check the version of rename
password="扶她奶茶"
rootPath=$(pwd)
# check if ex exists
if [ -d "$rootPath/ex" ];then
    rm -r ex
    rarDirs=$(ls -F | grep "/$")
    mkdir ex
else
    rarDirs=$(ls -F | grep "/$")
    mkdir ex
fi
#take off all space chars from file/dir names
rename 's/ /_/g' *
#mkdir tmp
for d in $rarDirs 
do
    #echo "$d"
    #get into dirs one by one 
    if [ -d "$d" ]; then
        cd "$(pwd)/$d" 
        if [ ! -d "$rootPath/ex/$d" ];
        then
            mkdir "$rootPath/ex/$d"
        fi
        find "$(pwd)" -name "*.rar"
        pwd
        rars=$(find "$(pwd)" -name "*.rar")
        echo $rars
        rarEx  "$rootPath" "$rars" "$d" "$password"
        
        # back to root dir
        cd ..
    fi
done
