#!/bin/bash

pingip="8.8.8.8"
pingtimes=1
totalms=0
mscount=0
avgms=0

while true; do
    ms=$(ping -c $pingtimes $pingip | awk '/time=/{print $7}' | cut -d '=' -f 2)

    if [[ -z $ms ]]; then
        echo "OFFLINE"
        echo "NO INTERNET CONNECTION"
    else
        totalms=$(echo "$totalms + $ms * $ms" | bc -l)
        mscount=$(echo "$mscount + $ms" | bc -l)
        avgms=$(echo "scale=1; $totalms / $mscount" | bc -l)
        
        if (( $(echo "$ms <= 85.0" | bc -l) )); then
            echo -e "\e[32mCurrent: $ms ms\e[0m"
            echo -e "\e[32mAverage: $avgms ms\e[0m"
        elif (($(echo "$ms <= 155.0" | bc -l) )); then
            echo -e "\e[33mCurrent: $ms ms\e[0m"
            echo -e "\e[33mAverage: $avgms ms\e[0m"
        else
            echo -e "\e[31mCurrent: $ms ms\e[0m"
            echo -e "\e[31mAverage: $avgms ms\e[0m"
        fi
    fi

    sleep 1

    read -n 1 -t 1 input

    # Check if the input is "q"
    if [[ $input == "q" ]]; then
        break
    fi

    # Move the cursor up two lines
    echo -ne "\033[2A"
done
