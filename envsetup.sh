# Run from root of repo with: "source build/envsetup.sh"
ORIG_PWD=$PWD

# Change to the build directory, no matter where in the EDK this script is
# sourced from.
# The "upsearch" function is courtesy of:
# http://unix.stackexchange.com/questions/13464/is-there-a-way-to-find-a-file-in-an-inverse-recursive-search/13474#13474
function upsearch () {
    test / == "$PWD" && return || test -e "$1" && return || cd .. && upsearch "$1"
}
upsearch ".repo"

# List configuration menu:
if [ -z $1 ] || [ -z $2 ] || [ "$1" == "menu" ]; then
    echo PLEASE SELECT A CONFIGURATION.
    echo CONFIG MENU:
    echo
    echo AVAILABLE TARGET PLATFORMS
    echo --------------------------------------------
    ls -1 build/menu/platforms
    echo
    echo AVAILABLE BUILD FLAVORS
    echo --------------------------------------------
    ls -1 build/menu/flavor
    echo
    echo TO SET CONFIG: source envsetup.sh \<PLATFORM\> \<FLAVOR\>
    echo FOR EXAMPLE: source envsetup.sh linux-default release
    echo

    cd $ORIG_PWD
    return 0
fi

# Set some search paths
export CANOPY_EMBEDDED_ROOT=$PWD
export LD_LIBRARY_PATH=$CANOPY_EMBEDDED_ROOT/build/_out/lib

source build/menu/platforms/$1 || (cd $ORIG_PWD || return)
source build/menu/flavor/$2 || (cd $ORIG_PWD || return)

export CANOPY_EDK_PLATFORM=$1
export CANOPY_EDK_FLAVOR=$2
export CANOPY_EDK_ENVSETUP=1

# Change back to the original directory where this script was sourced from.
cd $ORIG_PWD
