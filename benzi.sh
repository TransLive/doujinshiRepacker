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
        echo $f | grep -E ".jpg|.png"
        if [ $? -eq 0 ];then
            i=$(expr $i + 1)
            if [ $i -ge 5 ];then
                return 1
            fi
        fi
        #type2: rar with folders in
        if [ -d "$f" ];then
            return 2
        fi
            
    done
    
    
}

function rarExt()
{
    rootPath="$1"
    rars="$2"
    rarDir="$3"
    password="$4"
    if [ -z "$rars" ];then 
        return 
    fi

    for rar in $rars
    do
        #make a dir in current dir uses rar's name
        extTmpDir=${rar%.rar}
        if [ ! -d "$extTmpDir" ]; then
            mkdir "$extTmpDir"
        fi

        unrar e -p"$password" "$rar" "$extTmpDir"
        rarType "$extTmpDir"
        _rarType=$?
        echo $_rarType
        #rm -r $extTmpDir
        #final step

        #type0: rar with rars in.extract to here,add all new rars' dir into $rars
        case $_rarType in 
        0)
        childRars=$(find "$extTmpDir" -name "*.rar")
        rarExt "$rootPath" "$childRars" "$rarDir" "$password"
        rm -r "${extTmpDir%/*}"
        ;;
        #type1: rar with jpgs in
        1)
        mv "$extTmpDir" "$rootPath/ex/$rarDir"
        ;;
        #type2: rar with folder in.immediately extract to final dir
        2)
        mv "$extTmpDir" "$rootPath/ex/$rarDir"
        ;;
        esac
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

#get into dirs one by one 
for rarDir in $rarDirs 
do
    #echo "$d"
    #make final dirs store the folders
    if [ -d "$rarDir" ]; then
        cd "$(pwd)/$rarDir" 
        if [ ! -d "$rootPath/ex/$rarDir" ];
        then
            mkdir "$rootPath/ex/$rarDir"
        fi       
        #
        rars=$(find "$(pwd)" -name "*.rar")
        rarExt  "$rootPath" "$rars" "$rarDir" "$password"

        # back to root dir
        cd ..
    fi
done

exit

cd ex
rename 's/ /_/g'
DIRS=$(ls ./)
for dir in $DIRS
do
    cd "$rootPath/ex/$dir"
    FILE=$(ls ./)
    for f in $FILE
    do
        echo $f
        zip -r "$rootPath/ex/$dir/$f".zip "$rootPath/ex/$dir/$f"
        rm -r "$rootPath/ex/$dir/$f"
    done
done
