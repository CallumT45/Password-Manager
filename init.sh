#!/bin/bash
 
user=$1
if [ $# -ne 1 ]; then
	echo "Error: The number of parameters is wrong" >&2
	exit 1
fi
./P.sh "$user"

if ! [ -d "users/$user" ]; then
	mkdir users/$user
	echo "Ok: User created"	
else
	echo "Error: This user already exists"
	exit 2

fi
./V.sh "$user"
