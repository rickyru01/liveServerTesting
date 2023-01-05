#!/bin/bash
#==============================================================================
# FileName: ldt-support.sh
# Author: Asaf Magen <asaf.magen@sap.com>
# Version: 1.1
#
# Owner: Ron Ayzenberg <ron.ayzenberg@sap.com> 
#
# Description:
# various tasks for Linux support.   
#
# Revision: 1.1
#==============================================================================

LOG_FULL_NAME="/var/ldt/log/ldt-support.log"
LDT_VERBOSE_OVR="false"
GET_LDT_CONF_DB_OVR='false'
#LDT_BRANCH_OVR="preprod"
LDT_MENU_OPT=$1
RED='\033[0;31m' #Red
GREEN='\033[0;32m' #Green
BLACK='\033[0m' # Black (No Color)
mkdir -p /var/ldt/log/
ldtMaster_url="https://linuxinfra.wdf.sap.corp/$LDT_BRANCH_OVR/ldtMaster.sh"

if [ "$EUID" -ne 0 ]; then
    printf "\nLDT_ERROR: You must have root access to use this script!"
    printf "\nRun first # <sudo bash> and then run the script.\n"
	exit 14
fi

#echo "Getting free space on root drive..."
if (df  / | grep -q "100%");then
        echo "LDT_ERROR: No free space on root drive."
        exit 14
fi

random_file="/tmp/$RANDOM$RANDOM"
if (! touch $random_file) >/dev/null 2>&1 || (touch $random_file | grep -iq "Read-only file system");then
	echo "LDT_ERROR: Read-only file system."
	exit 14
else
	[[ -n $random_file ]] && [[ -f $random_file ]] && rm -f $random_file
fi

echo "Check Connection..."
if (! ping -q -c2 linuxinfra.wdf.sap.corp >/dev/null 2>&1);then
	echo "LDT_ERROR: Faild to ping linuxinfra.wdf.sap.corp"
	exit 14
fi
if (curl -v -x '' -s --head $ldtMaster_url 2>&1 | egrep -q 'server certificate verification OK|SSL certificate verify ok') || (curl -f -v -x '' -s --head $ldtMaster_url >/dev/null 2>&1) ;then
	echo "LDT_INFO: Client Certificate OK"
else
	echo  "LDT_WARN: Your machine is missing SAP Certificates."
	echo  "ldt-support might fail to load."
	echo  "please run below command and try again:"
	echo  "curl -k -s -x '' https://linuxinfra.wdf.sap.corp/ldt/scripts/ldt.certificates.sh |  bash"
fi


#remvoing old ldt.conf variable that is casing issues and is not needed anymore.
[[ -f /var/ldt/ldt.conf ]] && sed -i '/LDT_DEPLOY_FILES_PATH=/d' /var/ldt/ldt.conf
[[ -f /var/ldt/ldt.conf.db ]] && sed -i '/LDT_DEPLOY_FILES_PATH=/d' /var/ldt/ldt.conf.db


echo "Sourcing ldtMaster.sh, Please wait..."
source /dev/stdin <<< "$(curl -f -s -x '' $ldtMaster_url)"
if  ! InitialRunArguments ;then
	echo "Sourcing remote ldtMaster...Failed!"
	echo "Script Exist!"
	echo "For any issues please contact ron.ayzenberg@sap.com"
	exit 14
fi

function SAP_menu() {

#\033[1m 9.Convert To LDT	\033[0m
	sleep 1
	PrintAndLog "\033[1m**** Test Env LDT Support Menu ****\033[0m
\033[1m##########################\033[0m\n
\033[1m 1.Join To GLOBAL Domain (Requires Mcafee and ForeScout)\033[0m
\033[1m 2.Install McAffe Isec Anti-Virus(New Version 10.7.4)	\033[0m
\033[1m 3.Install SAP Repositories	\033[0m
\033[1m 4.Add Users to admins group (wheel group)	\033[0m
\033[1m 5.Install Raccount	\033[0m
\033[1m 6.Install Security Updates Only	\033[0m
\033[1m 7.Install MS Teams client (only for Ubuntu machines) \033[0m
\033[1m 8.Install ForeScout User	\033[0m
\033[1m 9.Install Citrix Workspace        \033[0m
\033[1m10.Install LDT Agent\033[0m
\033[1m11.Linux Admin Info Menu	\033[0m
\033[1m12.Install SAP JAVA	\033[0m
\033[1m13.Install Chef	\033[0m
\033[1m14.RHEL Minor releases Upgrade\033[0m
\033[1m15.Configure NTP (Sync Time with SAP Servers)\033[0m
\033[1m16.SLES SP Upgrade\033[0m
\033[1m17.Add SAP Certificates To Firefox \033[0m
\033[1m18.NAC - Make Me Compliant Tool\033[0m
\033[1m19.Add SAP Certificates To native tools (wget, curl, git ... ) \033[0m
\033[1m20.Install Google Chrome Browser \033[0m
\033[1m21.Install Code42 CrashPlan (Physical machines only) \033[0m
\033[1m22.Remove User from admins group (wheel group)	\033[0m
\033[1m23.Add SAP VPN Gateways Bookmarks for FireFox\033[0m
\033[1m24.Drivers Installation Menu	\033[0m
\033[1m25.Install Zabbix Client	\033[0m
\033[1m26.Delete Proxy settings for ProxyLess device \033[0m
\033[1m27.Set the Screenlock delay to 15 minutes\033[0m
\033[1m97.LDT (FixIT) Scripts Menu\033[0m
\033[1m98.LDT (Beta) Scripts Menu\033[0m
\033[1m99.Display Script Log File	\033[0m
\033[1m100.About	\033[0m
\033[1m0. EXIT
                   \033[0m"
     
}

function SAP_Beta_Menu(){

	sleep 1
	PrintAndLog "\\033c"
	PrintAndLog "\033[1m**** LDT Support - Beta Scripts Menu ****\033[0m
\033[1m#######################################\033[0m\n
\033[1m 101.Install Vastool (new version 4.1.1.22824))\033[0m
\033[1m 102.Install MS Skype\033[0m
\033[1m   0.EXIT \033[0m"
	SAP_read_case_map "^101$|^102$|^0$"
}

function FixIt_Menu(){
	sleep 1
	PrintAndLog "\\033c"
	PrintAndLog "\033[1m**** LDT FixIT - Scripts Menu ****\033[0m
\033[1m#######################################\033[0m\n
\033[1m 201.Suse Wicked Fix\033[0m
\033[1m 202.Show Desktop Icons Fix\033[0m
\033[1m   0.EXIT \033[0m"	
	SAP_read_case_map "^201$|^202$|^0$"
}	  

function Drivers_Menu(){
	sleep 1
	PrintAndLog "\\033c"
	PrintAndLog "\033[1m**** Drivers Menu ****\033[0m
\033[1m#######################################\033[0m\n
\033[1m 401.Install Nvidia Drivers\033[0m
\033[1m   0.EXIT \033[0m"	
	SAP_read_case_map "^401$|^0$"
}

function JoinDomainMenu(){

		PrintAndLog "\\033c"
		PrintAndLog "\033[1m**** LDT Support - Join Domain Settings Menu ****\033[0m
\033[1m#######################################\033[0m\n
\033[1m 301.Rejoin Domain Keeping Current Settings. (Recommended)\033[0m
\033[1m 302.LDT Recommended Settings. (Home folder: [/home] , Shell: [/bin/bash])\033[0m
\033[1m 303.Active Directory based configuration. (https://dewdflattr01.wdf.sap.corp//)\033[0m
\033[1m   0.EXIT \033[0m

*** Current Settings: ***
LDT_AUTH: [$LDT_AUTH]
LDT_AUTH_USER_OVERRIDE: [$LDT_AUTH_USER_OVERRIDE] (LDT Recommended)
"
		SAP_read_case_map "^301$|^302$|^303$|^0$"
		
	
}

function SAP_read_case_map() {

if [ -z $LDT_MENU_OPT ] ; then
	[[ -n $1 ]] && num_option="$1" || unset num_option
	PrintAndLog "\nEnter your choice from the menu: \c"
	read  < /dev/tty
	local choice=$REPLY
	
	#validate correct option number was  selected.
	if [[ -n $num_option ]] && (! egrep "$num_option" <<< "$choice") ; then
		PrintAndLog "\n${RED}LDT_ERROR:${BLACK} Incorrect option number [$choice].
Available options are:\n$(echo $num_option | grep -Eo '[0-9]*')\n"	
		return	
	fi
	
	ImSure || return
	PrintAndLog "
* If the process takes long time you can view it progress
  with below command in a separate shell.
# tail -f $LOG_FULL_NAME
"
else
	choice=$LDT_MENU_OPT
	unset LDT_MENU_OPT
fi
	case $choice  in 
		1)  
			JoinDomainMenu
			;;
		2)  SupportStats $choice; PrintAndLog "Installing McAffe Isec Anti-Virus..."; InstallMcafeeIsec ; PrintResults ;;
		3)  SupportStats $choice; PrintAndLog "Installing SAP Repositories..." ; UpdateRepoFile ;PrintResults ;; 
		4)  SupportStats $choice; PrintAndLog "Type the user to add...\n* one user at a time.\nExample i01234"
			PrintAndLog "Current Admins: \n$(cat /etc/group|grep wheel|rev|cut -d: -f1|rev)\n"
			read  < /dev/tty
			local admin_users=$REPLY
			[[ -n $admin_users ]] || { PrintResults && return ; }
			PrintAndLog "Adding Users to wheel (admin group)..."
			AddAdmin $admin_users
			PrintAndLog "Current Admins: \n$(cat /etc/group|grep wheel|rev|cut -d: -f1|rev)\n"
			;;
		5)  SupportStats $choice; PrintAndLog "Installing Raccount..." ; SetRaccount ;PrintResults ;;
		6)  SupportStats $choice; PrintAndLog "Installing Security Updates Only..." ; InstallSecurityUpdates;;
		7)  SupportStats $choice; PrintAndLog "installing MS teams client".. ; InstallMSTeams;PrintResults ;;
		8)  SupportStats $choice; PrintAndLog "Installing ForeScout User..." ; SetForeScoutUser;PrintResults ;;
		9)  SupportStats $choice; PrintAndLog "Installing Citrix Workspace..."; InstallCitrix; PrintResults ;;
		10) SupportStats $choice; PrintAndLog "Install LDT Agent " ;InstallLdtAgent ;;
		11) SupportStats $choice ;PrintAndLog "Loading Linux Admin Info Menu" ; sleep 2
			(curl -s -x '' https://linuxinfra.wdf.sap.corp/ldt/scripts/linux_admin_info.sh | bash) >&3  ;;
		12) SupportStats $choice; PrintAndLog "Installing SAP JAVA..." ; InstallSapJava ; PrintResults ;;
		13) SupportStats $choice; PrintAndLog "Installing Chef...\c" ; InstallChef ; PrintResults ;;
		14) SupportStats $choice; (curl -s -x '' https://linuxinfra.wdf.sap.corp/ldt/scripts/redhat.upgrade.sh | bash) >&3  ;;
		15) SupportStats $choice; PrintAndLog "Configuring NTP..." ; NTPConfiguration ; PrintResults ;;
		16) SupportStats $choice; (curl -s -x '' https://linuxinfra.wdf.sap.corp/ldt/scripts/sles.sp.upgrade.sh | bash) >&3  ;;
		17) SupportStats $choice; PrintAndLog "Installing Firefox with SAP Certificates..." ; ConfigureInternetBrowser ; PrintResults ;;
		18) SupportStats $choice; PrintAndLog "Starting NAC Make Me Compliant Tool..." ; sleep 2
			cd /tmp/
			curl -f -s -x '' https://linuxinfranac.wdf.global.corp.sap/ldt/nac/linux_nac.installer.sh > linux_nac.installer.sh
			chmod +x linux_nac.installer.sh
			linux_nac.installer.sh > /dev/tty 2>&1
			;;
		19) SupportStats $choice; PrintAndLog "Installing SAP Certificates to native tools...\c" ; ConfigureBinCerts ; PrintResults ;;
		20) SupportStats $choice; PrintAndLog "Installing Chrome...\c" ; InstallChrome ; PrintResults ;;
		21) SupportStats $choice; PrintAndLog "Installing Code42 CrashPlan...\c" ; InstallCode42 ; PrintResults ;;
		22) SupportStats $choice; PrintAndLog "Type the user to remove...\n* one user at a time.\nExample i01234"
			PrintAndLog "Current Admins: \n$(cat /etc/group|grep wheel|rev|cut -d: -f1|rev)\n"
			read  < /dev/tty
			local admin_users=$REPLY
			[[ -n $admin_users ]] || { PrintResults && return ; }
			PrintAndLog "Removing User from wheel (admin group)..."
			RemoveAdmin $admin_users
			PrintAndLog "Current Admins: \n$(cat /etc/group|grep wheel|rev|cut -d: -f1|rev)\n"
			;;
		23) SupportStats $choice; PrintAndLog "Updating VPN bookmarks...\n\c" ; SetVpnBookmarks ; PrintResults ;;
		24) Drivers_Menu ;;	
		25) SupportStats $choice; InstallZabbix ; PrintResults ;;
		26) SupportStats $choice; PrintAndLog "Deleting proxy settings...\c" ; DeleteProxySettings ; PrintResults ;;				
		27) SupportStats $choice; PrintAndLog "Updating the settings...\c"
			curl -s -x '' https://linuxinfra.wdf.sap.corp/ldt/scripts/update_idle_period.sh | bash >&3 
			PrintResults
			;;
		97) FixIt_Menu ;;	
		98) SAP_Beta_Menu ;;
		99) SupportStats $choice; vi -R +1 $LOG_FULL_NAME > /dev/tty < /dev/tty ;;
		100) PrintAndLog "----(Version 1.1)----\nDevelopers: ron.ayzenberg@sap.com " ;;
		101) SupportStats $choice; PrintAndLog "Installing Vastool (New Version 4.1.1.22824) ... \c" ; InstallNewVastool ; PrintResults ;;
		102) SupportStats $choice; PrintAndLog "Installing Ms Skype ... \c" ; InstallMsSkype ; PrintResults ;; 
		201) SupportStats $choice; (curl -s -x '' https://linuxinfra.wdf.sap.corp/ldt/scripts/ldt.wicked.fix.sh | bash) >&3  ;;
		202) SupportStats $choice; PrintAndLog "Running Desktop Icons Fix, when done logoff and relogin"
			GsettingIcons 
 			;;
		301)
			SupportStats $choice
			PrintAndLog "Joining Domain With [$LDT_AUTH] keeping current settings ..."			
			JoinDomain ; PrintResults 
			;;
		302)
			SupportStats $choice
			AddToLdtConf "LDT_AUTH_USER_OVERRIDE" "true"
			PrintAndLog "Joining Domain With [$LDT_AUTH] LDT Recommended Settings ..."
			JoinDomain ; PrintResults 
			;;
		303)
			SupportStats $choice
			AddToLdtConf "LDT_AUTH_USER_OVERRIDE" "false"
			PrintAndLog "Joining Domain With [$LDT_AUTH] Active Directory based configuration ..."			
			JoinDomain ; PrintResults 
			;;
		401) 	SupportStats $choice
			if (! lspci |grep -iq nvidia) ; then
				PrintAndLog "It does not seem that you have NVIDIA card in your system!!!.\nAre you sure you want to continue?\n\nPress ENTER to contunue or Ctrl C to Exit."
				read  < /dev/tty
			 fi
			 PrintAndLog "Current RunLevel: [$(runlevel | rev | awk '{print $1}')]
* Installing Nvidia Drivers should be done while the GUI is down.
* Connect via ssh to your host or switch to text mode terminal and run [init 3] to make sure the GUI is down.

Press ENTER to contunue or Ctrl C to Exit."
			 read  < /dev/tty
			PrintAndLog "Instlling Nvidia Drivers..."
			InstallNvidia ; PrintResults ;;
		0) exit 0 ;;
		*) PrintAndLog "\033[41mIncorrect option selected ...!\033[0m" ;;
		esac
}

#trap '' SIGINT SIGQUIT SIGTSTP
			  
function SAP_wait() {
      PrintAndLog  "\033[1m\033[34mPress \033[41m ENTER \033[0m\033[1m\033[34m key to continue.........\033[0m"
       #read  fackEnterKey
	   read < /dev/tty 
       
}

function PrintResults(){
	if [ $? -eq 0 ] ; then
		PrintAndLog "${GREEN}[OK]${BLACK} ." 
	else
		PrintAndLog "${RED}[FAILED]${BLACK} ."
	fi
}
	   
function CleanSettings(){
[[ -e /var/ldt/ldt.conf ]] && sed -i '/LDT_SUPPORT_*/d' /var/ldt/ldt.conf
}

function show_help() { 

PrintAndLog " 
Options:
-a  > Join To GLOBAL Domain.
-b  > Install McAffe Anti Virus.
-c  > Install SAP Repositories.
-d  > Add Users to wheel (admin group) .
      * example: [-d i123456,i35455,c45566]	
-e  > Install Raccount.
-f  > Install SAP Agent.
      * Includes Security Updates and Inventory tool.
-g  > Install ForeScout User.
-h  > Show Help.
-i  > Install Security Updates Only.
-j  > Configure SAP Proxy.
How to use this script with curl:
example:
curl -s -x '' FULL_URL_TO_THIS_SCIRPT | bash -s -- -a

"
}

function ImSure(){

PrintAndLog "Please confirm (Yy/Nn) and press Enter: \c"
read < /dev/tty
if [[ $REPLY =~ ^[Yy]$ ]] ; then
	return 0
else
	CleanSettings
	PrintAndLog "Selection Cancelled..."
	return 14
fi
}

function InstallNewVastool(){
	
	case $PACKAGE_MANAGER_BIN in 
		rpm|dnf)
			AddRepo "vastoolbeta" "https://linuxinfra.wdf.sap.corp/ldt/repos/beta/vastool/rpm/"
			;;
		dpkg)
			AddRepo "vastoolbeta" "https://linuxinfra.wdf.sap.corp/ldt/repos/beta/vastool/deb/ stable main"
		;;
		*)
		echo "LDT_ERRO: Unknown package manager."
		return 14
	esac
	
	if JoinDomain && RemoveRepo "vastoolbeta" ; then
		echo "LDT_INFO: new version installed successfully."
		return 0
	else
		echo "LDT_ERRO: Failed to install the new vastool version"
		return 14
	fi
}

function InstallMsSkype(){
	
	case $PACKAGE_MANAGER_BIN in 
		rpm|dnf)
			AddRepo "msskype" "https://linuxinfra.wdf.sap.corp/ldt/repos/beta/rpm/"
			;;
		dpkg)
			AddRepo "msskype" "https://linuxinfra.wdf.sap.corp/ldt/repos/beta/deb/ stable main"
		;;
		*)
		echo "LDT_ERRO: Unknown package manager."
		return 14
	esac
	
	
	if Installing_With_Installer_Manager "skypeforlinux" && RemoveRepo "msskype" ; then
		echo "LDT_INFO: skypeforlinux installed successfully."
		return 0
	else
		echo "LDT_ERRO: Failed to install skypeforlinux"
		return 14
	fi
}

while true
    do
    PrintAndLog "\\033c"
    [[ -z  $LDT_MENU_OPT ]] && SAP_menu
    SAP_read_case_map
	PrintAndLog "Done"
	[[ -z $LDT_MENU_OPT ]] && exit
	SAP_wait		
done
  
