#!/bin/bash

# Function to display active ports and services
if [[ "$1" == "-p" || "$1" == "--port" ]]; then
    if [[ -n "$2" ]]; then
        sudo netstat -tuln | grep "$2" 
    else
        sudo netstat -tuln | awk '
        BEGIN {
            print "+----------------------+----------------------+---------+"
            print "| Local Address        | Foreign Address      | State   |"
            print "+----------------------+----------------------+---------+"
        }
        NR>2 {
            split($4, addr, ":")
            printf "| %-20s | %-20s | %-7s |\n", addr[1] ":" addr[2], $7, $6
        }
        END {
            print "+----------------------+----------------------+---------+"
        }'
    fi
    
else
    echo "Invalid option. Use -p or --port to display active ports or detailed information about a specific port."
fi
