#!/bin/bash
set -e

url='https://raw.githubusercontent.com/bayraktarulku/jitsi-meet/mute-unmute/'
lib_url='https://raw.githubusercontent.com/bayraktarulku/lib-jitsi-meet/mute-unmute/'

echo "#####################################"
echo "# developer-setup script is started #"
echo "#####################################"
echo
curl "https://raw.githubusercontent.com/bayraktarulku/jitsi-meet-dev/master/scripts/developer-setup.sh" | bash

echo
echo "####################################"
echo "# JICOFO #"
echo "####################################"
echo

if [[ -d jicofo ]]
then
    cd jicofo
    sed -i '/do not allow unmuting/,/}/ s~^~//~' src/main/java/org/jitsi/jicofo/JitsiMeetConferenceImpl.java
    mvn package -DskipTests -Dassembly.skipAssembly=false
    mvn install
    unzip target/jicofo-1.1-SNAPSHOT-archive.zip
    cp jicofo-1.1-SNAPSHOT/jicofo.jar /usr/share/jicofo/
    /etc/init.d/jicofo restart && /etc/init.d/jitsi-videobridge2 restart && /etc/init.d/prosody restart
    cd ../
else
    echo "not found jicofo repository"
    exit 1
fi

echo
echo "####################################"
echo "# JITSI-MEET #"
echo "####################################"
echo

if [[ -d jitsi-meet ]]
then
    cd jitsi-meet
    for f in $(cat /home/jitsi-path-list.txt) ; do
	    curl $url$f --create-dirs -o $f
    done
    rm -rf node_modules package-lock.json
    cd ..
else
    echo "not found jitsi-meet repository"
    exit 1
fi

echo
echo "####################################"
echo "# LIB-JITSI-MEET #"
echo "####################################"
echo

if [[ -d lib-jitsi-meet ]]
then
    cd lib-jitsi-meet
    for f in $(cat /home/lib-path-list.txt); do
	    curl $lib_url$f --create-dirs -o $f
    done
    rm -rf node_modules package-lock.json
    npm update && npm install
    cd ..
else
    echo "not found lib-jitsi-meet repository"
    exit 1
fi

cd jitsi-meet/
npm update && npm install
npm install lib-jitsi-meet --force && make
