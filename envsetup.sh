# Run from root of repo with: "source build/envsetup.sh"
ORIG_PWD=$PWD
INTERACTIVE=1

# Change to the build directory, no matter where in the EDK this script is
# sourced from.
# The "upsearch" function is courtesy of:
# http://unix.stackexchange.com/questions/13464/is-there-a-way-to-find-a-file-in-an-inverse-recursive-search/13474#13474
function upsearch () {
    test / == "$PWD" && return || test -e "$1" && return || cd .. && upsearch "$1"
}
upsearch ".repo"

PLATFORM=$1
FLAVOR=$2

# List configuration menu:
if [ -z $1 ] || [ -z $2 ] || [ "$1" == "menu" ]; then

    # Dialog menu for platform selection
    PLATFORM_MENU_ITEMS=`ls build/menu/platforms | sed -e 's/\(^.*\)/\1\ platform /' | tr -d '\n'`
    exec 3>&1
    PLATFORM=$(dialog --no-cancel --menu "SELECT TARGET PLATFORM" 18 50 15 $PLATFORM_MENU_ITEMS 2>&1 1>&3)
    exitcode=$?
    exec 3>&-;

    if [ $exitcode -ne 0 ]; then
        INTERACTIVE=0
    fi

    if [ $INTERACTIVE -eq 0 ]; then
        echo
        echo PLEASE SELECT A CONFIGURATION.
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
        echo For interactive version of this script: apt-get install dialog
        echo
        echo
        cd $ORIG_PWD
        return 0
    fi

    # Dialog menu for flavor selection
    FLAVOR_MENU_ITEMS=`ls build/menu/flavor | sed -e 's/\(^.*\)/\1\ flavor /' | tr -d '\n'`
    exec 3>&1
    FLAVOR=$(dialog --no-cancel --menu "SELECT BUILD TYPE" 18 50 15 $FLAVOR_MENU_ITEMS 2>&1 1>&3)
    exitcode=$?
    exec 3>&-;

    clear
fi

# Set some search paths
export CANOPY_EMBEDDED_ROOT=$PWD
export LD_LIBRARY_PATH=$CANOPY_EMBEDDED_ROOT/build/_out/lib

source build/menu/platforms/$PLATFORM || (cd $ORIG_PWD || return)
source build/menu/flavor/$FLAVOR || (cd $ORIG_PWD || return)

# Force clean: remove _out directory
rm -r build/_out

export CANOPY_EDK_PLATFORM=$PLATFORM
export CANOPY_EDK_FLAVOR=$FLAVOR
export CANOPY_EDK_ENVSETUP=1

echo CONFIGURING BUILD ENVIRONMENT:
echo ------------------------------
echo PLATFORM: $PLATFORM
echo FLAVOR: $FLAVOR
echo
echo Now type \"make\" to build.


# Change back to the original directory where this script was sourced from.
cd $ORIG_PWD
