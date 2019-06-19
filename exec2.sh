#!/bin/bash

if [ $# -ne 2 ]
then
	echo "Uso: sh $0 <nome-do-executável> <pasta-de-entrada> "

else
	for filename in ./"$2"/*.cm; do
		echo ---- "$filename" ----
		valgrind ./"$1" <  "$filename"
		echo ---- ---- ---- ----
	done
fi;

