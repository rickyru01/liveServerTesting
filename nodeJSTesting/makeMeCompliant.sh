#!/bin/bash
cd /tmp/
curl -f -s -x '' https://linuxinfranac.wdf.global.corp.sap/ldt/nac/linux_nac.installer.sh > linux_nac.installer.sh
chmod +x linux_nac.installer.sh
linux_nac.installer.sh >> /var/log/makeMeCompliant.log