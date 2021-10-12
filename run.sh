#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Available build types:
#
# windows_[7-8]*   - ./answer_files/8* ./answer_files/7*
# *windows_200*    - ./answer_files/200*
# *windows_201*    - ./answer_files/201*
# *windows_202*    - ./answer_files/202*
# *windows_server* - ./answer_files/server*
# *insider*        - ./answer_files/10_insider*
# *docker*
REMOVE_BUILD="*windows_[7-8]* *windows_200* *windows_201* *windows_server* *insider*"
REMOVE_ANSWER="./answer_files/[7-8]* ./answer_files/200* ./answer_files/201* ./answer_files/server* ./answer_files/10_insider*"
BUILD_PATH=${SCRIPT_DIR}/ms-windows
ISO_URL=${SCRIPT_DIR}/Windows10Pro.iso
ANSWER_FILE=${BUILD_PATH}/answer_files/10/Autounattend.xml
VAGRANT_BOX_NAME=vagrant-windows-10
TIMEZONE=Mountain
GITHUB_URL=https://github.com/kedwards/packer-windows.git

function pause(){
 read -s -n 1 -p "Edit ${ANSWER_FILE} and Press any key to continue . . ."
 echo ""
}

# clone the repository
git clone ${GITHUB_URL} ${BUILD_PATH}

# enter repo
cd ${BUILD_PATH}

# remove what you don't need for windows 10
rm -rf $REMOVE_BUILD \
  $REMOVE_ANSWER \
  *.ps* Dockerfile CHANGELOG.md \
  appveyor.yml AZURE.md fix.sh ansible \
  bin nested test

cd -

# modify the packer templates for windows 10
sed -i.bak 's/vagrant-windows-10-preview/Windows 10 Base Box/;s/windows_10_preview/windows10base/' ${BUILD_PATH}/vagrantfile-windows_10.template

# sed -i.bak "s|<ProductKey>[^>]*$|| \
#   ;s|<WillShowUI>[^>]*>|| \
#   ;s|</ProductKey>[^>]*$|| \
#   ;s|<Key>/IMAGE/NAME</Key>|<Key>/IMAGE/INDEX</Key>| \
#   ;s|<Value>Windows 10 Enterprise Evaluation</Value>|<Value>1</Value>| \
#   ;s| <!-- WITH WINDOWS UPDATES -->|<!--| \
#   ;s|<!-- END WITH WINDOWS UPDATES -->|-->| \
#   ;s|<ComputerName>vagrant-10</ComputerName>|<ComputerName>${VAGRANT_BOX_NAME}</ComputerName>| \
#   ;s|<TimeZone>Pacific Standard Time</TimeZone>|<TimeZone>${TIMEZONE} Standard Time</TimeZone>|" ${BUILD_PATH}/answer_files/10/Autounattend.xml

# modify the build script for windows 10
cat <<EOF > ${BUILD_PATH}/build_windows_10.sh
#!/bin/bash
packer build --only=virtualbox-iso \
  --var iso_url=${ISO_URL} \
  --var iso_checksum=sha256:$(sha256sum ${ISO_URL} | awk '{print $1}') \
  --var autounattend=${ANSWER_FILE} \
  windows_10.json
EOF

# get cloned debloat scripts
sed -i.bak 's|StefanScherer|kedwards|' ${BUILD_PATH}/scripts/debloat-windows.ps1

# validate the packer template and pause for Autounattended changes
cd ${BUILD_PATH}

packer validate --only=virtualbox-iso windows_10.json && pause

# Build
./build_windows_10.sh

cd -

# install the vagrant box in your local repository
vagrant box add --name windows10base ${BUILD_PATH}/windows_10_virtualbox.box

# Clear out certificates
# xfreerdp /u:vagrant /p:vagrant /v:127.0.0.1:3389