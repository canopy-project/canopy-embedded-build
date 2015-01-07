#!/bin/bash
if [ -z "$CANOPY_EMBEDDED_ROOT" ]; then
    echo "CANOPY_EMBEDDED_ROOT must be set."
    echo "Please run 'source build/envsetup.sh' from parent directory"
    exit 1
fi

OUTDIR=$CANOPY_EMBEDDED_ROOT/build/_out/canopy-edk-0.9.0-src
mkdir -p $OUTDIR
rsync -qav --exclude=".*" $CANOPY_EMBEDDED_ROOT/3rdparty $OUTDIR
rsync -qav --exclude=".*" $CANOPY_EMBEDDED_ROOT/demos $OUTDIR
rsync -qav --exclude=".*" $CANOPY_EMBEDDED_ROOT/libcanopy $OUTDIR
rsync -qav --exclude=".*" $CANOPY_EMBEDDED_ROOT/libsddl $OUTDIR
rsync -qav --exclude=".*" $CANOPY_EMBEDDED_ROOT/build/envsetup.sh $OUTDIR/build/
rsync -qav --exclude=".*" $CANOPY_EMBEDDED_ROOT/build/makefile $OUTDIR/build/
rsync -qav --exclude=".*" $CANOPY_EMBEDDED_ROOT/build/README.md $OUTDIR/build/
cd $CANOPY_EMBEDDED_ROOT/build/_out && tar -czvf canopy-edk-0.9.0-src.tgz canopy-edk-0.9.0-src/
