#!/bin/bash

set -x
# make sure the test file does not have the min_version to start with
bm="erc777"
folder_min="./contracts/${bm}"
file="./test_longTrace/${bm}_test_gas.js"
build_path="./build/contracts"
i=1
for min in "$folder_min"/*
do 
	# compile solidity after removing all files in build
	if [ -n "$(ls -A $build_path)" ]; then
	    # Use rm -r to delete all files and subdirectories in the folder
	    rm -r "$build_path"/*
	fi
	if [ -f "$file" ]; then
		truffle compile "${min}"
	fi
	# add the min_versoin to the test file
	new_line="const min_version = ${i};"
	temp_file=$(mktemp)
	echo "$new_line" | cat - "$file" > "$temp_file"
	mv "$temp_file" "$file"

	# run test
	truffle test "./test_longTrace/${bm}_test_gas.js" --compile-none
	# delete the first line of the test file
	sed -i '' 1d "${file}"
	((i++))
done


