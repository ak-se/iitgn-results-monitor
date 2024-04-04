#!/bin/bash

# Function to display countdown timer
countdown_timer() {
    local seconds="$1"
    while [ "$seconds" -gt 0 ]; do
        printf "\rNext check in: %02d:%02d" $((seconds / 60)) $((seconds % 60))
        sleep 1
        ((seconds--))
    done
    echo ""
}

# Function to check if there's a difference between the previous and current results
check_difference() {
    current_result=$(curl -s https://iitgn.ac.in/admissions/results | grep "AY: 2024-25")

    if [ "$current_result" != "$previous_result" ]; then
        if [ -n "$previous_result" ]; then
            echo "Alert: There is a difference between the previous run and the new run!"
            # Print the output of the curl command
            echo "Current result:"
            echo "$current_result"
            # Cause a terminal alert and beep
            tput bel
        fi
    else
        echo "No difference detected."
        # echo "$previous_result"
    fi

    # Update the previous result
    previous_result="$current_result"
}

# Initialize previous_result variable with the first result
previous_result=$(curl -s https://iitgn.ac.in/admissions/results | grep "AY: 2024-25")

# Infinite loop to run the check every 15 minutes
while true; do
    # Calculate remaining time until the next loop
    countdown_timer 900
    
    # Perform the check
    check_difference
done
