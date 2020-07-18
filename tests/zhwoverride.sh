#!/bin/sh
#
# Install zhw with a few overrides and then ensure the zFS files are laid down
#
. zospmsetenv
#set -x

sw='zhw110'

zosinfo=`uname -rsvI`
version=`echo ${zosinfo} | awk '{ print $3; }'`
release=`echo ${zosinfo} | awk '{ print $2; }'`

case ${release} in
	'03.00' ) 
		export ZOSPM_ZOS230_CSI='MVS.GLOBAL.CSI'
		;;
	'04.00' )
		export ZOSPM_ZOS240_CSI='MVS.GLOBAL.CSI'
		;;
esac

zospm deconfigure zhw110
rc=$?
if [ $rc != 0 ]; then
        echo "zospm deconfigure failed with rc:$rc" >&2
        exit 3
fi

zospm -c install zhw110
rc=$?
if [ $rc != 0 ]; then
        echo "zospm install clean failed with rc:$rc" >&2
        exit 3
fi

zospm smpreceiveptf zhw110 MCSPTF2  
rc=$?
if [ $rc != 0 ]; then
        echo "zospm receive ptf from z/os file failed with rc:$rc" >&2
        exit 4
fi

zospm update zhw110
rc=$?
if [ $rc != 0 ]; then
        echo "zospm update of zhw110 failed with rc:$rc" >&2
        exit 5
fi

zospm configure zhw110
rc=$?
if [ $rc -gt 4 ]; then
        echo "zospm configure failed with rc:$rc" >&2
        exit 6
fi

zospm deconfigure zhw110
rc=$?
if [ $rc != 0 ]; then
        echo "zospm uninstall failed with rc:$rc" >&2
        exit 7
fi

zospm uninstall zhw110
rc=$?
if [ $rc != 0 ]; then
        echo "zospm uninstall failed with rc:$rc" >&2
        exit 8
fi

exit 0
