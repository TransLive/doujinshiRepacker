#!/bin/sh
#put this script into root directory of mangas
function rarType()
{  
    
    rename 's/ /_/g' $1/*
    files=$(ls $1)

    i=0
    for f in $files
    do
        #type0: rar with rars in
        echo $f | grep .rar
        if [ $? -eq 0 ];then 
            i=$(expr $i + 1)
            if [ $i -ge 5 ];then 
                return 0
            fi
        fi
        #type1: rar with jpgs in
        echo $f | grep .jpg
        if [ $? -eq 0 ];then
            i=$(expr $i + 1)
            if [ $i -ge 5 ];then
                return 1
            fi
        fi
        #type2: rar with folders in
        if [ test -d "$f" ];then
            return 2
        fi
            
    done
    
    
}

function rarExt()
{
    rootPath="$1"
    d="$3"
    password="$4"
    if [ -z "$rars" ];then 
        return 
    fi

    for r in $rars
    do

        extTmpDir=${r%.rar}
        if [ ! -d "$extTmpDir" ]; then
            mkdir "$extTmpDir"
        fi
        
        unrar e -p"$password" "$r" "$extTmpDir"
        rarType "$extTmpDir"
        _rarType=$?
        echo $_rarType
        rm -r $extTmpDir
    #exit
        #unrar x -p$password "$r" "$rootPath/tmp"
        #type0: rar with rars in.extract to here,add all new rars' dir into $rars
        # if [ _rarType -eq 0 ];
        # then
        #     rName=$(basename $r)
            
        #     echo ----------------------------
        # fi
        #type1: rar with jpgs in
        # elif [ rarType==1 ];then

        # fi
        # #type2: rar with folder in.immediately extract to final dir
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
        rars=$(find "$(pwd)" -name "*.rar")
        rarExt  "$rootPath" "$rars" "$d" "$password"
        
        # back to root dir
        cd ..
    fi
done
