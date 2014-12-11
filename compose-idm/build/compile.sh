#!/bin/bash

rm -r bin
rm -fr compose-idm
git clone https://github.com/nopobyte/compose-idm
git checkout review
cp ./files/*.properties compose-idm/src/main/resources/
cd ./compose-idm
#sed 's/gradle /\/vagrant\/gradle-2.1\/bin\/gradle /' compile_war.sh>compile_war_vagrant.sh
#chmod +x compile_war_vagrant.sh
./compile_war.sh
mkdir ../bin
cp ./build/libs/* ../bin
cd ../
