#!/bin/bash -e

# arguments accepted: sourcedir
usage() {
        echo "Usage: $0 <sourcedir> <destdir>"
}

# check arguments
if [ $# != 2 ]; then
        usage
        exit 1
fi

sourcedir="$1"
if [ ! -d "$sourcedir" ]; then
	echo sourcedir \"sourcedir\" does not exist!
	usage
	exit 1
fi

destdir="$2"
if [ ! -d "$destdir" ]; then
	echo destdir \"destdir\" does not exist!
	usage
	exit 1
fi

# relative to absolute paths
sourcedir=`readlink -f "$sourcedir"`
destdir=`readlink -f "$destdir"`

# BUILDING STARTS HERE
pushd "$sourcedir"

# build configuration
XSERVER_GREATER_THAN_13=1
BUILD_HARD_VFP=1
BUSID_HAS_NUMBER=1
NODRI=0
export XSERVER_GREATER_THAN_13 BUILD_HARD_VFP BUSID_HAS_NUMBER NODRI

# build
./fastbuild.sh

# install
install -v -m755 -D EXA/src/vivante_drv.so "${destdir}/usr/lib/xorg/modules/drivers/vivante_drv.so"
install -v -m755 -D FslExt/src/libfsl_x11_ext.so "${destdir}/usr/lib/xorg/modules/extensions/libfsl_x11_ext.so"
install -v -m755 -D util/autohdmi/autohdmi "${destdir}/usr/bin/autohdmi"

popd
# END
