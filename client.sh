#!/bin/bash
clientid=$1
req=$2

if [ $# -lt 2 ]; then
	echo "Error: Number of arguments suplied is invalid" >&2
	exit 1 
fi
if [ ! -p "server.pipe" ]; then
	echo "Error: Server is not running"
	exit 1
fi

if [ ! -p "$clientid.pipe" ]; then
	mkfifo $clientid.pipe
fi
masterPass="TempPass"
case "$req" in init)
			if [[ $clientid =~ ^id ]] && [ $# -eq 3 ]; then
				echo "$@" > server.pipe
				cat "$clientid.pipe"
			else
				echo "Error: Input incorrect"
			fi
		;;
		insert)
			if [[ $clientid =~ ^id ]] && [ $# -eq 4 ]; then

				echo "Please write login!" 
				read login
				echo "Please write password, Type 'G' to autogenerate a password!"
				read password
				if [[ $password == "G" ]]; then
					password=$(./PassGen.sh)
					echo "Your password is $password"
				fi
				
				enPass=$(./encrypt.sh $masterPass $password)
				#echo $enPass
				#echo "client insert"
				echo "$clientid" "$req" "$3" "$4" "${login}" "$enPass" > server.pipe
				
				cat $clientid.pipe
			else
				echo "Error: Input incorrect"
			fi
		;;
		show)
			if [[ $clientid =~ ^id ]] && [ $# -eq 4 ]; then
				echo "$@" > server.pipe
				payload=$(cat $clientid.pipe)
				n="\n"
				ciphertext=${payload##*${n}}
				
				dePass=$(./decrypt.sh $masterPass $ciphertext)
				
				output="${3}'s login for $4 is: ""${payload%%${n}*}n${3}'s password for $4 is: $dePass"
				echo -e $output
				
			else
				echo "Error: Input incorrect"
			fi 
		;;
		edit)
			if [[ $clientid =~ ^id ]] && [ $# -eq 4 ]; then
				echo "$clientid" "show" "$3" "$4" > server.pipe
				tempf=$(mktemp)
				n="\n"
				info=$(cat "$clientid.pipe")
				login0="${info%%${n}*}"
				password0="${info##*${n}}"
				dePass=$(./decrypt.sh $masterPass $password0)
				echo "$login0""n""$dePass" > $tempf
				vi $tempf
			
				payload=$(cat $tempf)
				login="${payload%%${n}*}"
				password="${payload##*${n}}"
				echo $login $password
				enPass=$(./encrypt.sh $masterPass $password)
				
				
				echo "$clientid" "update" "$3" "$4" "$login" "$enPass" > server.pipe
				cat $clientid.pipe
				rm ${tempf}
			else
				echo "Error: Input incorrect"
			fi
	
		;;
		rm)
			if [[ $clientid =~ ^id ]] && [ $# -eq 4 ]; then
				echo "$@" > server.pipe
				cat "$clientid.pipe"
			else
				echo "Error: Input incorrect"
			fi

		;;
		ls)
			if [[ $clientid =~ ^id ]]; then
				echo "$@" > server.pipe
				cat "$clientid.pipe"
			else
				echo "Error: Input incorrect"
			fi
		;;
		shutdown)
			echo "$@" > server.pipe
			cat "$clientid.pipe"

		;;
		*)
		echo "Error:bad request"
		exit 2
	esac
rm "$clientid.pipe"

