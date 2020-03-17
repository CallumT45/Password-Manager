#!/bin/bash
string="abcdefghijk"
num=$(( RANDOM % 10 ))

feed1="$$""$num""$string"
feed2="$feed1"

Start=3
End=20

feed3=$( echo "$feed2" | sha512sum | sha512sum )

randomstr="${feed3:$Start:$End}"

echo $randomstr
