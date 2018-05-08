sleep 1
set -e

while true;
do
        mongo --eval "db.runCommand( { serverStatus: 1 } )" db/local > /dev/null 2>&1
        if [ $? -eq 0 ]; then
                break;
        fi
        echo "waiting for mongod start..."
        sleep 1
done

echo " [+] Preparing db"
cd /userconfig
mongo db/catapult < mongoDbPrepare.js
echo " [.] (exit code: $?)"
cd -

echo " [+] db prepared, checking account indexes"
mongo --eval 'db.accounts.getIndexes()' db/catapult

trap 'echo "successful; exiting"; exit 0' SIGTERM


