#!/bin/bash
if [ -z "$CANOPY_EMBEDDED_ROOT" ]; then
    echo "CANOPY_EMBEDDED_ROOT must be set."
    echo "Please run 'source build/envsetup.sh' from parent directory"
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: ./make_x86_64_release.sh <ver>"
    echo "Expected <ver>"
    exit 1
fi

OUTDIR=$CANOPY_EMBEDDED_ROOT/build/_out/canopy-edk-${1}-x86_64
rm -rf _out
make
mkdir -p $OUTDIR
rsync -qav --exclude=".*" _out/linux-default_release/include $OUTDIR
rsync -qav --exclude=".*" _out/linux-default_release/lib $OUTDIR
cd $CANOPY_EMBEDDED_ROOT/build/_out && tar -czvf canopy-edk-${1}-x86_64.tgz canopy-edk-${1}-x86_64/
