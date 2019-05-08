#!/bin/bash

echo -e "What IP or Subnet would you like to scan?\n"
	read IP
echo -e "What interface would you like to use?\n"
	read INT
echo -e "What directory would you like to place the output in? (ex. /root/foo/bar/nmap/\n"
	read PATH
echo -e "Would you like to create this directory? (Y/n)\n"
	read ANSWER

if [ $ANSWER = "Y" -o $ANSWER = "y" ]
then
	/usr/bin/mkdir -p $PATH
	/usr/bin/masscan -p1-65535 -pU:1-65535 $IP --rate=1000 -e $INT > ports.txt
	ports=$(/usr/bin/cat ports.txt | /usr/bin/awk -F " " '{print $4}' | /usr/bin/awk -F "/" '{print $1}' | /usr/bin/sort -n | /usr/bin/tr '\n' ',' | /usr/bin/sed 's/,$//')
	/usr/bin/nmap -Pn -sV -sC -p$ports  -oA "$PATH"full-tcp $IP
	/usr/bin/nmap -Pn -sU -sV -sC -p$ports -oA "$PATH"full-udp $IP

elif [ $ANSWER = "N" -o $ANSWER = "n" ]
then
	/usr/bin/masscan -p1-65535 -pU:1-65535 $IP --rate=1000 -e $INT > ports.txt
	ports=$(/usr/bin/cat ports.txt | /usr/bin/awk -F " " '{print $4}' | /usr/bin/awk -F "/" '{print $1}' | /usr/bin/sort -n | /usr/bin/tr '\n' ',' | /usr/bin/sed 's/,$//')
	/usr/bin/nmap -Pn -sV -sC -p$ports  -oA "$PATH"full-tcp $IP
	/usr/bin/nmap -Pn -sU -sV -sC -p$ports -oA "$PATH"full-udp $IP

else
	echo ERROR: invalid option: exiting 1>&2
	exit 1
fi

#/usr/bin/masscan -p1-65535 -pU:1-65535 $IP --rate=1000 -e $INT > ports.txt
#ports=$(/usr/bin/cat ports.txt | /usr/bin/awk -F " " '{print $4}' | /usr/bin/awk -F "/" '{print $1}' | /usr/bin/sort -n | /usr/bin/tr '\n' ',' | /usr/bin/sed 's/,$//')
#/usr/bin/nmap -Pn -sV -sC -p$ports  -oA "$PATH"full-tcp $IP
#/usr/bin/nmap -Pn -sU -sV -sC -p$ports -oA "$PATH"full-udp $IP
