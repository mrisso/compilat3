#!/bin/bash

if [ $# -ne 3 ]
then
	echo "Uso: sh $0 <nome-do-executável> <pasta-de-entrada> <pasta-de-gabarito>"

else
	for filename in ./"$2"/*.cm; do
		echo ---- "$filename" ----
		./"$1" <  "$filename" | diff "$3/$(basename "$filename" .cm).out" -
		echo ---- ---- ---- ----
	done
fi;

