#!/usr/bin/env bash
#Created by DF4U1T
#Prompts for IP/Subnet to scan, interface to use, and will either create a new directory or use an existing directory for nmap output
echo -e "What IP or Subnet would you like to scan?\n"
	read IP
echo -e "What interface would you like to use?\n"
	read INT
echo -e "What directory would you like to place the output in? (ex. /root/foo/bar/nmap/\n"
	read DIR
echo -e "Would you like to create this directory? (Y/n)\n"
	read ANSWER

if [ $ANSWER = "Y" -o $ANSWER = "y" ]
then
	mkdir -p $DIR
	masscan -p1-65535 -pU:1-65535 $IP --rate=10000 -e $INT > "$DIR"ports.txt
	ports=$(cat "$DIR"ports.txt | awk -F " " '{print $4}' | awk -F "/" '{print $1}' | sort -n | tr '\n' ',' | sed 's/,$//')
	nmap -Pn -sV -sC -p$ports  -oA "$DIR"full-tcp $IP
	nmap -Pn -sU -sV -sC -p$ports -oA "$DIR"full-udp $IP
	rm "$DIR"ports.txt

elif [ $ANSWER = "N" -o $ANSWER = "n" ]
then
	masscan -p1-65535 -pU:1-65535 $IP --rate=1000 -e $INT > "$DIR"ports.txt
	ports=$(cat "$DIR"ports.txt | awk -F " " '{print $4}' | awk -F "/" '{print $1}' | sort -n | tr '\n' ',' | sed 's/,$//')
	nmap -Pn -sV -sC -p$ports  -oA "$DIR"full-tcp $IP
	nmap -Pn -sU -sV -sC -p$ports -oA "$DIR"full-udp $IP
	rm "$DIR"ports.txt

else
	echo ERROR: invalid option: exiting 1>&2
	exit 1
fi
