#!/bin/bash
# ChangeNetVM.sh

# Check if notify-send, zenity, and xdotool are available
if ! command -v notify-send &> /dev/null || ! command -v zenity &> /dev/null || ! command -v xdotool &> /dev/null; then
    echo "Error: notify-send, zenity, and xdotool are required. Please install them to use notifications, dialogs, and window ID detection." >&2
    exit 1
fi

# Get the window ID of the focused window
WINDOW_ID=$(xdotool getwindowfocus)

while read -r vm; do
    if xprop -id "${WINDOW_ID}" | grep -q "_QUBES_VMNAME(STRING) = \"${vm}\""; then
        notify-send "Info" "Detected AppVM: ${vm}"
        APPVM="${vm}"
        break
    fi
done < <(qvm-ls --no-spinner --fields=name | grep "^[^ ]" | grep -v NAME)

if [ -n "${APPVM}" ]; then
    # Get the list of NetVMs that provide network connectivity
    NETVM_LIST=$(qvm-ls --no-spinner --fields=name,provides_network | awk '$NF=="True"{print $1}' | while read -r vm; do
        provides_network=$(qvm-prefs --get "${vm}" provides_network 2>/dev/null)
        if [ "${provides_network}" = "True" ]; then
            echo "${vm}"
        fi
     done)

    # Use zenity to prompt the user to select from the list
    NEW_NETVM=$(zenity --list --title="Change NetVM" --text="Select the new NetVM for ${APPVM}:" --column="NetVM" ${NETVM_LIST[@]})

    # Check if the user canceled the dialog or did not select any option
    if [ -z "${NEW_NETVM}" ]; then
        notify-send "Error" "User canceled the operation or did not select a NetVM."
        exit 1
    fi

    # Change the NetVM for the detected AppVM
    qvm-prefs "${APPVM}" netvm "${NEW_NETVM}"

    # Notify about the change
    notify-send "Success" "NetVM for ${APPVM} changed to ${NEW_NETVM}"
else
    notify-send "Error" "No Qubes AppVM detected for the focused window."
fi
