#! /bin/bash    
if [ $# != 1 ]
then
    echo "Usage: exam1.sh filename"
    exit 0
else
    INPUT="helloworld"
    while [ $INPUT ]
    do
        read INPUT
        echo "$INPUT">>$1
    done
    echo "the content of $1 is "
    cat $1
fi

