#!/bin/bash
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_ESC=255}

# install prereqs
apk add -U dialog >/dev/null 2>&1

export APP_TITLE="Terra OS"
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPTDIR=${BASE_DIR}/scripts
export MIRROR=${MIRROR:-"-1"}
export LOG=/tmp/terra-install.log

tmpfile=$(tempfile 2>/dev/null) || tmpfile=/tmp/test$$
trap "rm -f $tmpfile" 0 1 2 5 15

truncate -s0 $LOG

dialog --clear --backtitle "$APP_TITLE" --msgbox  \
    "Welcome to Terra OS!" 8 50

while true
do
    dialog --clear --backtitle "$APP_TITLE" --menu "Terra OS Installer" \
        15 50 8 \
        hostname "Configure Hostname" \
        network "Configure Network" \
        system "Install System" \
        reboot "Reboot" 2> $tmpfile
    rval=$?
    case $rval in
        $DIALOG_OK)
            $SCRIPTDIR/$(cat $tmpfile)
            # catch exit from script to exit installer
            if [ $? -eq 255 ]; then
                exit 0
            fi
            ;;
        $DIALOG_CANCEL)
            sleep 2
            ;;
        $DIALOG_ESC)
            echo "Exiting..."
            exit 0
            ;;
        *)
            sleep 5
            ;;
    esac
    sleep 3
done
