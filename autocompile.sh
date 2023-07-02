#!/bin/bash

# Variable to store the hash of the previously compiled file
prev_hash=""

# Function to compile and execute the program
compile_and_execute() {
    # Compile the C program
    gcc -o output_file input_file.c

    # Execute the compiled program and discard stderr
    result=$(./output_file 2>/dev/null)

    # Print the output, replacing the previous output
    printf "\r%s" "$result"
}

# Initial compilation and execution
compile_and_execute

# Watch for changes to the C program file
while true; do
    # Get the hash of the modified file
    curr_hash=$(md5sum input_file.c | awk '{print $1}')

    # Compare the current hash with the previous hash
    if [ "$curr_hash" != "$prev_hash" ]; then
        # Update the previous hash with the current hash
        prev_hash="$curr_hash"

        # Delay for a short period before recompiling and executing
        sleep 0.5

        # Recompile and execute the program
        compile_and_execute
    fi

    # Delay before checking for changes again
    sleep 1
done
