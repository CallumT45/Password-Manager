#!/bin/bash
user=$1
service=$2
payload=$4
path=users/$user/$service
pathnoW=$(echo -e $path | tr -d '[:space:]')
servicenoW=$(echo -e $service | tr -d '[:space:]')
shortpath=$(dirname $servicenoW)
#shortpath=$(echo $pathnoW | cut -d'/' -f-3)
#char="/"
#num=$(echo "$service" | awk -F"${char}" '{print NF-1}')

#echo $user
#echo $service
#echo $shortpath


if [ $# -ne 4 ]; then
	echo "Error: Number of parameters is wrong" 
	exit 1
elif [ ! -d "users/$user" ]; then
	echo "Error: User does not exist"
	exit 2
fi

./P.sh "$user"

if [ "$shortpath" != "." ]; then
		
	if [ ! -d "users/$user/$shortpath" ]; then
		mkdir -p "users/$user/$shortpath"
		echo "OK: Directory created"
	fi
fi
./V.sh "$user"

./P.sh "$pathnoW"

if [ $3 == 'f' ]; then
	echo $payload > $pathnoW
	echo "OK: Service Updated"
	./V.sh "$pathnoW"
	exit 0
else
	
	if [ -e "users/$user/$servicenoW" ]; then
		echo "Error: Service already exists"
		./V.sh "$pathnoW"
		exit 3
	else
		echo $payload > $pathnoW	
		echo "OK: Service Created"
		./V.sh "$pathnoW"
		exit 0
	fi
fi








