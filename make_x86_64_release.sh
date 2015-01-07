#!/bin/bash
if [ -z "$CANOPY_EMBEDDED_ROOT" ]; then
    echo "CANOPY_EMBEDDED_ROOT must be set."
    echo "Please run 'source build/envsetup.sh' from parent directory"
    exit 1
fi

OUTDIR=$CANOPY_EMBEDDED_ROOT/build/_out/canopy-edk-0.9.0-x86_64
rm -rf _out
make
mkdir -p $OUTDIR
rsync -qav --exclude=".*" _out/include $OUTDIR
rsync -qav --exclude=".*" _out/lib $OUTDIR
cd $CANOPY_EMBEDDED_ROOT/build/_out && tar -czvf canopy-edk-0.9.0-x86_64.tgz canopy-edk-0.9.0-x86_64/
