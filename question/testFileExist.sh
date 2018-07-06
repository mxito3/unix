#! /bin/bash
result=$(find -name te)
if [ $result != ' ' ]
then 
    echo "存在"
else
    echo "不存在"
fi
