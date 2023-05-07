#!/bin/bash
file="${1:? <file_with_users.csv>}"
function creategroup(){
	IFS=',' read -ra linearr <<< "${@}"
	for i in "${linearr[@]:1}"; do
		if [ ! $(getent group "${i}") ]; then
       			 groupadd "${i}"
       			 else
               		 echo "group "${i}" exists"
		fi
	done
}

function createuser(){
	IFS=',' read -ra linearr <<< "${@}"
	useradd -p $(openssl passwd "${linearr[0]}")  "${linearr[0]}"
	passwd -e "${linearr[0]}"
	
	
	#add users to appropriate group
	for i in "${linearr[@]:1}"; do
		gpasswd -a "${linearr[0]}" "${i}"
	done
}

function main(){
	mapfile -t arr < "${file}"
	for i in "${arr[@]}"; do
		creategroup "${i}";
	done
	for i in "${arr[@]}"; do
		createuser "${i}"; 
	done	
}
main "${@}"