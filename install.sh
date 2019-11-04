#!/bin/sh
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_ESC=255}

# install prereqs
apk add -U dialog bash

TITLE="Terra OS"
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPTDIR=${BASE_DIR}/scripts

tmpfile=$(tempfile 2>/dev/null) || tmpfile=/tmp/test$$
trap "rm -f $tmpfile" 0 1 2 5 15

dialog --clear --backtitle "$TITLE" --msgbox  \
    "Welcome to Terra OS!" 8 51

while true
do
    dialog --clear --backtitle "$TITLE" --menu "Terra OS Installer" \
            18 51 8 \
            hostname "Configure Hostname" \
            network "Configure Network" \
            system "Install System" \
            reboot "Reboot" 2> $tmpfile

    rval=$?
    case $rval in
        $DIALOG_OK)
            $SCRIPTDIR/$(cat $tmpfile)
            ;;
        $DIALOG_CANCEL)
            ;;
        $DIALOG_ESC)
            echo "Canceling install..."
            exit 0
            ;;
        *)
            sleep 2
            ;;
    esac
done
