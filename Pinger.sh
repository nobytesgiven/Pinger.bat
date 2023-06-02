#!/bin/bash

pingip="8.8.8.8"
bytelength=1
pingtimes=1
totalms=0
mscount=0
avgms=0

while true; do
    ms=$(ping -c $pingtimes -s $bytelength $pingip | awk '/ttl=/{print $6}' | cut -d '=' -f 2 | cut -d ' ' -f 1)

    if [[ -z $ms ]]; then
        echo "OFFLINE"
        echo "NO INTERNET CONNECTION"
    else
        totalms=$((totalms + ms))
        mscount=$((mscount + 1))
        avgms=$((totalms / mscount))
        
        if (( ms <= 85 )); then
            echo -e "\e[32mCurrent: $ms ms\e[0m"
        elif (( ms <= 155 )); then
            echo -e "\e[33mCurrent: $ms ms\e[0m"
        else
            echo -e "\e[31mCurrent: $ms ms\e[0m"
        fi
        
        if (( avgms == 0 )); then
            echo -e "Average: $ms ms"
        else
            echo -e "Average: $avgms ms"
        fi
    fi

    sleep 1

    read -n 1 -t 1 input

    # Check if the input is "q"
    if [[ $input == "q" ]]; then
        break
    fi
    
    if (( $mscount > 25 )); then
        break
    fi
    # Move the cursor up two lines
    echo -ne "\033[2A"
done
