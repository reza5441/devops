#!/bin/bash
apt-get update
#set -x

# Definitions: You can change kernel version by changing `kernelVersion` and `kernelDate` by browsing `kernelUrl`
libsslName='libssl1.1_1.1.0g-2ubuntu4.3_amd64.deb'
libsslName=$(curl -s 'http://security.ubuntu.com/ubuntu/pool/main/o/openssl/?C=M;O=D' | egrep 'href="libssl[0-9]' | grep amd64.deb | sed "s/.*a href=\"\(.*\)\">libssl.*/\1/" | head -n1)
libsslName='libssl1.1_1.1.0g-2ubuntu4_amd64.deb'
kernelUrl='https://kernel.ubuntu.com/~kernel-ppa/mainline'
baseDir='/usr/local/src/kernel'

tmpVersion=$(curl ${kernelUrl}/ | sed "s/.*href=\"\(.*\)\/\".*/\1/" | egrep "^v" | grep -v 'rc' | sort -Vr | head -n1 | sed 's/v//g')
tmpDate=$(curl ${kernelUrl}/v${tmpVersion}/ | sed "s/.*href=\(\".*\.deb\"\).*/\1/" | grep linux | grep amd64 | head -n1 | sed "s/.*\.\([0-9]*\)_amd64.*/\1/g")
kernelVersion=${tmpVersion}
kernelDate=${tmpDate}

tmpChecksum="$(mktemp -p /dev/shm/)"


# Main
kernelMajor=$(echo ${kernelVersion} | cut -d. -f1)
kernelManor=$(echo ${kernelVersion} | cut -d. -f2)
kernelPatch=$(echo ${kernelVersion} | cut -d. -f3 | sed "s/\-.*"//g)

if [ "${#kernelMajor}" -lt "2" ]; then kernelMajor=0${kernelMajor}; fi
if [ "${#kernelManor}" -lt "2" ]; then kernelManor=0${kernelManor}; fi
if [ "${#kernelPatch}" -lt "2" ]; then kernelPatch=0${kernelPatch}; fi

kernelId="${kernelMajor}${kernelManor}${kernelPatch}"

echo ; echo ;
echo "To Download: ${kernelVersion}"
echo "Kernel Date: ${kernelDate}"

echo ; echo ;

mkdir -p ${baseDir}/kernel-${kernelVersion}-${kernelDate}
cd ${baseDir}/kernel-${kernelVersion}-${kernelDate}

curl -s https://kernel.ubuntu.com/~kernel-ppa/mainline/v${kernelVersion}/amd64/CHECKSUMS > ${tmpChecksum}
nameLinuxHeadersAll=$(egrep "linux-headers.*all.deb" ${tmpChecksum} | head -n1 | awk '{print $2}')
nameLinuxHeadersGeneric=$(egrep "linux-headers.*generic" ${tmpChecksum} | head -n1 | awk '{print $2}')
nameLinuxHeadersLow=$(egrep "linux-headers.*lowlatency" ${tmpChecksum} | head -n1 | awk '{print $2}')
nameLinuxImageGeneric=$(egrep "linux-image.*generic" ${tmpChecksum} | head -n1 | awk '{print $2}')
nameLinuxImageLow=$(egrep "linux-image.*lowlatency" ${tmpChecksum} | head -n1 | awk '{print $2}')
nameLinuxModulesGeneric=$(egrep "linux-modules.*generic" ${tmpChecksum} | head -n1 | awk '{print $2}')
nameLinuxModulesLow=$(egrep "linux-modules.*lowlatency" ${tmpChecksum} | head -n1 | awk '{print $2}')

echo 'Downloading openSSL library' && \
wget -nc http://security.ubuntu.com/ubuntu/pool/main/o/openssl/${libsslName} && \
echo "Downloading Kernel's files" && \
wget -nc https://kernel.ubuntu.com/~kernel-ppa/mainline/v${kernelVersion}/amd64/${nameLinuxHeadersAll} && \
wget -nc https://kernel.ubuntu.com/~kernel-ppa/mainline/v${kernelVersion}/amd64/${nameLinuxHeadersGeneric} && \
wget -nc https://kernel.ubuntu.com/~kernel-ppa/mainline/v${kernelVersion}/amd64/${nameLinuxHeadersLow} && \
wget -nc https://kernel.ubuntu.com/~kernel-ppa/mainline/v${kernelVersion}/amd64/${nameLinuxImageGeneric} && \
wget -nc https://kernel.ubuntu.com/~kernel-ppa/mainline/v${kernelVersion}/amd64/${nameLinuxImageLow} && \
wget -nc https://kernel.ubuntu.com/~kernel-ppa/mainline/v${kernelVersion}/amd64/${nameLinuxModulesGeneric} && \
wget -nc https://kernel.ubuntu.com/~kernel-ppa/mainline/v${kernelVersion}/amd64/${nameLinuxModulesLow}

rm ${tmpChecksum}

echo "Download Completed."
cd ${baseDir}/kernel-${kernelVersion}-${kernelDate}
echo "Update Kernel starting ..."

dpkg -i ./l*
apt-get -f install  -y
dpkg -i ./l*
apt-get upgrade -y
apt-get update
apt-get upgrade -y
apt --fix-broken install -y
apt-get update
apt-get upgrade -y

echo '#################################################'
echo '#################################################'
echo '#######  PLEASE REBOOT SERVE NOW!  ##############'
echo '#################################################'
echo '#################################################'

exit 0



