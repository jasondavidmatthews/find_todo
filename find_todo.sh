#!/bin/sh
#
# Searches files for TODO statements

get_files_only=false
get_comments_only=false

while getopts ":hfc" opt; do
	case $opt in
		f)
			get_files_only=true
			;;
		c)
			get_comments_only=true
			;;
		h)
			echo "Usage: find_todo.sh <options>"
			echo ; echo "Options:"
			echo "TODO files only: -f"
			echo "TODO comments only: -c"
			exit 0
			;;
		\?)
			echo "Invalid Option: -$OPTARG" >&2
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires and argument.">&2
			exit 1
			;;
	esac
done

if ! "$get_comments_only"; then
	echo "TODO files ------------------------------------------------------"
	for file in $(find . -type f | grep TODO); do
		echo ; echo "File: $file"
		cat $file;
	done
	echo
	echo "-------------------------------------------------------------done"
fi

if ! "$get_files_only"; then
	echo "TODO comments ---------------------------------------------------"
	for file in $(find . -type f); do
		if grep -q "TODO" $file; then
			echo ; echo "File: $file"
			grep -A 5 "TODO" $file; # 5 lines after to give some context
		fi
	done
	echo
	echo "-------------------------------------------------------------done"
fi
