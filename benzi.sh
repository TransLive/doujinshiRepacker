#!/bin/sh
#put this script into root directory of mangas
function rarType()
{  
    local files=$(ls $1)
    local i=0
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
    local rootPath="$1"
    local rars="$2"
    local rarDir="$3"
    local password="$4"
    local delFlag="$5"
    t=0
    if [ -z "$rars" ];then 
        return 
    fi
    local rar
    for rar in $rars
    do
        #make a dir in current dir uses rar's name
        local extTmpDir
        extTmpDir=${rar%.rar}
        if [ ! -d "$extTmpDir" ]; then
            mkdir "$extTmpDir"
        fi
        unrar e -y  -p"$password" "$rar" "$extTmpDir"
        rename 's/ /_/g' $extTmpDir/*
        if [ "$delFlag" -eq 0 ];then
            rm $rar
        fi
        
        rarType "$extTmpDir"
        local _rarType=$?
        echo $_rarType

        #final step
        #type0: rar with rars in.extract to here,add all new rars' dir into $rars
        case $_rarType in 
        0)
            local childRars=$(find "$extTmpDir" -name "*.rar")
            rarExt "$rootPath" "$childRars" "$rarDir" "$password" "0"
            delFlag=1
        ;;
        #type1: rar with jpgs in
        1)
            mv "$extTmpDir" "$rootPath/ex/$rarDir"
        ;;
        #type2: rar with folders in.immediately extract to final dir
        2)
            cd "$extTmpDir"
            local extTmpDirs=$(ls -F | grep "/$")
            for d in $extTmpDirs
            do
                rarType "$d"
                mv "$extTmpDir" "$rootPath/ex/$rarDir"
            done
            cd -
        ;;
        esac

        #delet tmp folder
        if [ -d "${rar%.rar*}" ];then 
            rm -r ${rar%.rar*}
            continue
        fi

        #repack
        cd "$rootPath/ex/$rarDir"
            ( 
            zip -r "${extTmpDir##*/}".zip "${extTmpDir##*/}"
            if [ -d "./${extTmpDir##*/}" ];then
                rm -r "./${extTmpDir##*/}"
            fi
            ) &
        cd -
    done
}

# TODO:check the version of rename
password="$1"
# until [ ! -z $password ]
# do
    read -p "此处输入密码：" password
# done
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
    cd $rarDirs
    rename 's/ /_/g' *
    cd -
    #make final dirs store the folders
    if [ -d "$rarDir" ]; then
        cd "$(pwd)/$rarDir" 
        if [ ! -d "$rootPath/ex/$rarDir" ];
        then
            mkdir "$rootPath/ex/$rarDir"
        fi       
        #
        rars=$(find "$(pwd)" -name "*.rar")
        rarExt  "$rootPath" "$rars" "$rarDir" "$password" "1"
        # back to root dir
        cd ..
    fi
done
exit