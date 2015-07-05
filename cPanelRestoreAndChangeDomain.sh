#!/bin/bash
#***** START OF CONFIGURATION *****#
#cPanel User
cPanelUserName=cpanelusername
#New cPanel User Password
cPanelUserPassword=myHardToGuessPassword123
#Assign Dedicated IP
cPanelDedicatedIP="123.123.123.123"
#Path of the file/package to be restored (example: /home/backupdir/cpmove-backup.tar.gz)
cPanelPackagePath="/home/cpanelbackup/backup/cpmove-cpanelusername.tar.gz"
#Current Domain Name
cPanelDomainName="mydomain.com"
#New Domain Name
cPanelNewDomainName="mydomain.net"
#***** END OF CONFIGURATION *****#

#***** START OF SCRIPT EXECUTION *****#
#Removing Account
/scripts/removeacct --force $cPanelUserName
#Restoring Account
/scripts/restorepkg --force --ip=$cPanelDedicatedIP $cPanelPackagePath
#Renaming Domain Name
mv /var/cpanel/userdata/$cPanelUserName/$cPanelDomainName /var/cpanel/userdata/$cPanelUserName/$cPanelNewDomainName
mv /var/cpanel/userdata/$cPanelUserName/$cPanelDomainName.cache /var/cpanel/userdata/$cPanelUserName/$cPanelNewDomainName.cache
sed -i -e "s/$cPanelDomainName/$cPanelNewDomainName/g" /var/cpanel/userdata/$cPanelUserName/$cPanelNewDomainName
rm -f /var/cpanel/userdata/$cPanelUserName/cache
sed -i -e "s/$cPanelDomainName/$cPanelNewDomainName/g" /var/cpanel/userdata/$cPanelUserName/main
rm -f /var/cpanel/userdata/$cPanelUserName/main.cache
sed -i -e "s/$cPanelDomainName/$cPanelNewDomainName/g" /var/cpanel/users/$cPanelUserName
#Renaming DNS Zones
mv /var/named/$cPanelDomainName.db /var/named/$cPanelNewDomainName.cache.db
sed -i -e "s/$cPanelDomainName/$cPanelNewDomainName/g" /var/named/$cPanelNewDomainName.cache.db
sed -i -e "s/$cPanelDomainName/$cPanelNewDomainName/g" /etc/named.conf
#Updating user domains, user data cache, apache configuration
/scripts/updateuserdomains
/scripts/updateuserdatacache --force $cPanelUserName
/scripts/rebuildhttpdconf
#Restarting Apache
/scripts/restartsrv_apache
#Reloading DNS Zones
/usr/sbin/rndc reload
#Changing User Password
export ALLOW_PASSWORD_CHANGE=1
/scripts/chpass $cPanelUserName $cPanelUserPassword
#Synching FTP pass
/scripts/ftpupdate
#***** END OF SCRIPT EXECUTION *****#