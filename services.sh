# !/bin/bash
    
    if [ $# != 2 ]
    then
        echo "please use service.sh serviceName servicePort"
        return
    else
        serviceName=$1
        servicePort=$2
        watchResult=$(netstat -ano |grep LISTEN|grep :::$servicePort)
        if [ "$watchResult" = "" ]
        then
            echo "service $serviceName is inactive"
        else
            echo "service $serviceName is active"
        fi
    fi
