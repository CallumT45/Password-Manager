#!/bin/bash

user=$1
folder=$2

if [ $# = 1 ]; then
	if [ ! -d "users/$user" ]; then
		echo "Error: User does not exist" >&2
		exit 2
	else
		tree users/$user
	fi

elif [ $# = 2 ]; then
	if [ ! -d "users/$user/$folder" ]; then
		echo "Error: Folder does not exist" >&2
		exit 3
	else 
		tree users/$user/$folder
	fi
else
	echo "Error: Incorrect number of parameters" >&2
	exit 4	
fi
