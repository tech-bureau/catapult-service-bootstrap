#!/bin/bash
ulimit -c unlimited
ls -alh /data

if [ -f /userconfig/prepare.sh ]
then
        if [ -z "$(grep 'catapult.*server' /userconfig/prepare.sh)" ]; then
                echo "proper server must be started via userconfig/prepare.sh"
                read -p "press enter to exit"
                exit 1
        fi

        exec /bin/bash /userconfig/prepare.sh
else
        echo "userconfig/prepare.sh not found"
        read -p "press enter to exit"
        exit 2
fi

