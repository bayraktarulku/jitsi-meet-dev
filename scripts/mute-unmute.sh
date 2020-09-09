#!/bin/bash
set -e

path="https://github.com/bayraktarulku/"
JICOFO="jicofo.git"
JITSIMEET="jitsi-meet.git"
LIBJITSIMEET="lib-jitsi-meet.git"
REPOSITORY=(
        "jicofo":$JICOFO
        "jitsi-meet":$JITSIMEET
        "lib-jitsi-meet":$LIBJITSIMEET)

for repo in "${REPOSITORY[@]}"
do
    key="${repo%%:*}"
    value="${repo##*:}"

    if [[ -d $key ]]
    then
        cd $key
        git pull
        cd ..
    else
        echo "$key repository is loading..."
        echo "$path$value"
        git clone $path$value
    fi
done


echo
echo "################################"
echo "# JICOFO #"
echo "################################"
echo

# added extra control --> if file doesn't exist
apt install -y maven
cd jicofo
mvn install
cd target
mv jicofo-1.1-SNAPSHOT-jar-with-dependencies.jar jicofo.jar
cp jicofo.jar /usr/share/jicofo/

/etc/init.d/jicofo restart && /etc/init.d/jitsi-videobridge2 restart && /etc/init.d/prosody restart
cd ../../

echo
echo "################################"
echo "# JITSI-MEET #"
echo "################################"
echo

# added extra control --> if file doesn't exist
cd jitsi-meet
rm -rf node_modules package-lock.json
github_url=`grep -i "lib-jitsi-meet" package.json`
file_url="    \"lib-jitsi-meet\": \"file:../lib-jitsi-meet\","
echo $github_url
echo $file_url
sed -zi "s|$github_url|$file_url|g" package.json


echo
echo "################################"
echo "# LIB-JITSI-MEET #"
echo "################################"
echo

# added extra control --> if file doesn't exist
cd ..
cd lib-jitsi-meet
# webpack
npm uninstall webpack
npm i -D webpack
npm update && npm install
cd ..

cd jitsi-meet/
npm install lib-jitsi-meet --force && make
