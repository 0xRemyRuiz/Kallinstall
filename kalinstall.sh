#!/bin/bash

_STEPS_FILENAME=".install.steps"
_STEPS=0
_MSG_1="===>"
_PREFIX_CHECK="####"
my_echo() {
	echo "$_MSG_1 $1"
}
check() {
	read -p "$_PREFIX_CHECK $1 <Y/n>" p
	# Parse a large number of possibilities to handle some typos
	if [[ -z $p \
		|| $p == "y" || $p == "yes" || $p == "ye" || $p == "yeah" \
		|| $p == "Y" || $p == "YES" || $p == "YE" || $p == "YEAH" \
		|| $p == "yy" || $p == "yyy" || $p == "YY" || $p == "YYY" ]]
	then
		true
	else
		false
	fi
}
# we're using the power of 2 to "mask" steps already done
# 0 no step is done yet
# 1 step 1 is done successfully
# 11 step 1 and 2 are done successfully
# 101 step 1 and 3 are done successfully but step 2 failed
# in the last case the number that would be written in the save file would be equal to 1 * (2 ^ 1) + 0 * (2 ^ 2) + 1 * (2 ^ 3)
# we're using the maths notation for which ^ symbol means "to the power of"
# in bash ^ means a bitwise XOR operation
2powStep() {
	# calculate mask from step number
	# minus 1 or else 2 ^ 1 would be equal to 2
	num=$(( $1 - 1 ))
	local res=1 i=0;
	while [ $i -lt $num ]; do
		res=$(( res * 2 ))
		i=$(( i + 1 ))
	done
	echo $res
}
set_step() {
	STEP=$(2powStep $1)
	# add the step mask with an OR bitwise operation
	_STEPS=$(( $_STEPS | $STEP ))
	# we rewrite the file everytime it is needed no necessity to optimize this but it's needed
	# TODO: sudo only remove and rewrite the isntalls steps file
	rm -f $_STEPS_FILENAME
	echo "_STEPS=$_STEPS" > $_STEPS_FILENAME
	echo "export _STEPS" >> $_STEPS_FILENAME
}
check_step() {
	STEP=$(2powStep $1)
	# if the steps AND the argument is equal to 0 it means the step has already been done
	if [[ $(( $_STEPS & $STEP )) == 0 ]]
	then
		true
	else
		false
	fi	
}

# TODO: make a check presence of the install steps file and display a message

# load steps already done if any
# the file is loaded and written as root to avoid basic injection problems linked to the usage of source command
# so it would not be possible to write to the file with any basic user privilege
# also, the file would not be readable from anyone but the root as it could leak config info
# TODO: add sudo -s if file exists
source $_STEPS_FILENAME

# TODO: change message is install step file exists already or not
my_echo "$0 Script is starting..."

step1() {
	check "First things first, do you want to change $(whoami) user's password?" &&\
	passwd
}
check_step 1 && step1 && set_step 1

# TODO: make a step mask so if a step fails so script can be relaunched without trying same steps again

step2() {
	my_echo "Making sure sources are correct"
	sudo sed -i 's/rolling main.*$/rolling main contrib non-free non-free-firmware/' /etc/apt/sources.list
	# try to update or exit the script
	sudo apt-get update || (my_echo "apt-get update failed, make sure you have internet conenction "; exit)
	sudo apt-get install apt-transport-https && sudo sed -i 's/http:/https:/' /etc/apt/sources.list
}
check_step 2 && step2 && set_step 2

step3() {
	check "Do you need to change your keyboard layout?" &&\
	sudo dpkg-reconfigure keyboard-configuration
}
check_step 3 && step3 && set_step 3

step4() {
	my_echo "Updating distro and installing basic stuff..."
	sudo apt-get full-upgrade && sudo apt-get install git gpg apt-transport-https xclip
}
check_step 4 && step4 && set_step 4

# TODO: maybe add ~/.local/bin to PATH env variable

step5() {
	my_echo "Installing python3 + venv + pip + pipx"
	sudo apt-get install python3-dev python3-pip python3-virtualenv python3-venv python3-scapy libssl-dev libpcap-dev
	updatedb
	pip install pipx && set_step 5
}
check_step 5 && step5

step6() {
	my_echo "Installing python2.7 + pip"
	sudo apt-get install python2.7
	wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
	python2 get-pip.py && set_step 6
}
check_step 6 && step6

# Base installation with yes skips optionals
check "Do you want to skip optionals?" &&\
exit

# TODO: continue coding and adding cool stuff (openvas?, docker?, portainer?)

# TODO: install oh my zsh and eventually kali's omz if using this script on parrot os

subl_install() {
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update -y && sudo apt-get install sublime-text -y && set_step 7
}
check_step 7 && check "Do you want to install SublimeText?" &&\
subl_install

chkrk_install() {
	sudo apt-get install chkrootkit -y
	my_echo "Running chkrootkit. Wait!"
	sudo chkrootkit > ./chkrootkit_log.txt && set_step 8
}
check_step 8 && check "Do you want to install chkrootkit?" &&\
chkrk_install

rkhunter_install() {
	sudo apt-get install rkhunter -y
	rkhunter --update
	rkhunter -c && set_step 9
}
check_step 9 && check "Do you want to install rkhunter?" &&\
rkhunter_install

lynis_install() {
	sudo apt-get install lynis -y
	my_echo "Running Lynis, please wait..."
	lynis audit system > ./.lynis_log.txt && set_step 10
}
check_step 10 && check "Do you want to install lynis?" &&\
lynis_install

opencanary_install() {
	virtualenv env/ #?? ??
	. env/bin/activate
	pip install opencanary && set_step 11
}
# check_step 11 && check "Do you want to install opencanary?" &&\
# opencanary_install

updatedb

# TODO: install htool and update path variables (both user and root?)
Htoolkit_install() {
	set_step 12
}
# check_step 12 && check "Do you want to install Htoolkit?" &&\
# Htoolkit_install

# TODO: remove the install steps file
# rm $_STEPS_FILENAME


