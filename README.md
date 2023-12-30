# ChangeNetVM.sh
QubesOS script to change NetVM of the window focused

# Description
ChangeNetVM.sh is a Bash script designed for use in a Qubes OS environment.

This script facilitates the process of changing the NetVM (Network Virtual Machine) associated with a focused Qubes AppVM.

# Prerequisites
Before using this script, ensure that the following tools are installed on your system:

- notify-send
- zenity
- xdotool

These tools are essential for providing notifications, user dialogs, and window ID detection.

```bash
# Check and install prerequisites
dom0# sudo qubes-dom0-update notify-send zenity xdotool
```
# Usage
1. Make the script executable:
```bash
dom0# chmod +x /usr/local/bin/ChangeNetVM.sh
```

2. Run the script:
```bash
/usr/local/bin/ChangeNetVM.sh
```
You can configure your desktop environment to run the script on keyboard shortcut.
```bash
dom0$ grep ChangeNetVM.sh ~/.config/i3/config
bindsym $mod+c exec /usr/local/bin/ChangeNetVM.sh
```

3. The script will identify the currently focused Qubes AppVM and prompt you to select a new NetVM from the available options.

4. Select the desired NetVM from the dialog presented by zenity.

5. The script will change the NetVM for the detected AppVM and notify you of the success or any errors.

# Important Notes
Ensure that the Qubes VMs are properly configured with NetVMs.

If the script reports missing dependencies, install them using the package manager appropriate for your system.

# Disclaimer
This script is provided as-is and without warranty. Use it at your own risk, and review the code to ensure it meets your security and system requirements.
