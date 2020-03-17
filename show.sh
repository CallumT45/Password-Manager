#!/bin/bash

user=$1
service=$2
input="users/$user/$service"
if [ $# -ne 2 ]; then
	echo "Error: Number of arguments supplied is invalid" >&2
	exit 1
elif [ ! -d "users/$user" ]; then
	echo "Error: User does not exist"
elif [ ! -e "users/$user/$service" ]; then
	echo "Error: Service does not exist"
	exit 3
else
	while IFS= read -r line
	do
		echo "$line"
	done < "$input"

fi
