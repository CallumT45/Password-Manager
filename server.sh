#!/bin/bash

if [ ! -p "server.pipe" ]; then
	mkfifo server.pipe
fi

while true; do
	read string < server.pipe
	#echo "Recieved from pipe: $input"
	#read string
	eval "myArray=($string)"
	clientid="${myArray[0]}"
	request="${myArray[1]}"
	user="${myArray[2]}"
	client_pipe="$clientid.pipe"
	case "$request" in 
		init)
			./init.sh $user > $client_pipe &
			
		;;
		insert)
			service="${myArray[3]}"
			payloadL="${myArray[4]}"
			payloadP="${myArray[5]}"
			payload="${payloadL}""\n""${payloadP}"
			up="d"
			
			
#			echo "./insert.sh $user $service $up $payload"
			./insert.sh $user "$service" $up "$payload" > $client_pipe &
		;;
		show)
			service="${myArray[3]}"
			./show.sh $user "$service" > $client_pipe &
		;;
		update)
			service="${myArray[3]}"
			payloadL="${myArray[4]}"
			payloadP="${myArray[5]}"
			payload="$payloadL""\n""$payloadP"
			up="f"
			#echo "from server" $user
			#echo "from server $payload"
			./insert.sh $user "$service" $up "$payload" > $client_pipe &
		;;
		rm)
			service="${myArray[3]}"
			./rm.sh $user "$service" > $client_pipe &
		;;
		ls)
			folder="${myArray[3]}"
			./ls.sh $user "$folder" > $client_pipe &
		;;
		shutdown)
			rm server.pipe
			echo "Server shutdown" > $client_pipe
			exit 0	
			break
		;;
		*)
		echo "Error: bad request"
		
	esac
done
