#!/bin/bash
user=$1
service=$2
servicenoW=$(echo -e $service | tr -d '[:space:]')


if [ $# -ne 2 ]; then
	echo "Error: Number of parameters is wrong" >&2
     	exit 1
elif [ ! -d "users/$user" ]; then
	echo "Error: User does not exist"
	exit 2
fi
./P.sh "$user"

if [ ! -e "users/$user/$servicenoW" ]; then
	echo "Error: Service does not exist" 
	./V.sh "$user"
	exit 3
else
	rm users/$user/$servicenoW
	echo "Ok: Service Deleted!"
	./V.sh "$user"
fi
