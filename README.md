cPanel Restore cpmove and Change domain name
============================================

This BASH script will automatically restore a cpmove cPanel backup, change the domain name, assign a new password for the user, fix DNS zones and synchronize the FTP passwords.

This will be done from the command line (SSH).

The script must run with root privileges, otherwise it won't work.

All you have to do is fill the configurations on top, and run the BASH script using the command: bash cPanelRestoreAndChangeDomain.sh

You may also add it to a cron job to perform this task frequently.