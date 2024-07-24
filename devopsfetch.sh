#!/bin/bash

# Main loop
while true; do
    cd functions
    echo "Choose an option to run:"
    echo "1. Show active ports (-p or --port)"
    echo "2. Show Docker images and containers (-d or --docker)"
    echo "3. Show Nginx domains and ports (-n or --nginx)"
    echo "4. List users and last login times (-u or --users)"
    echo "5. Show activities within a time range (-t or --time)"
    echo "6. Exit"
    read -p "Enter your choice [1-6]: " choice

    case "$choice" in
        1)
            read -p "Enter option (-p or --port) and port number (if specific): " option port
            if [[ -z "$port" ]]; then
                ./show_ports.sh "$option"
            else
                ./show_ports.sh "$option" "$port"
            fi
            ;;
        2)
             read -p "Enter option (-d or --docker) and conatiner name (if specific): " option container
            if [[ -z "$container" ]]; then
                ./show_docker.sh "$option"
            else
                ./show_docker.sh "$option" "$container"
            fi
            ;;
        3)
             read -p "Enter option (-n or --nginx) and domain name (if specific): " option domain
            if [[ -z "$domain" ]]; then
                ./show_nginx.sh "$option"
            else
                ./show_nginx.sh "$option" "$domain"
            fi
            ;;
        4)
            read -p "Enter option (-u or --users) and username (if specific): " option username
            if [[ -z "$username" ]]; then
                ./show_users.sh "$option"
            else
                ./show_users.sh "$option" "$username"
            fi
            ;;
        5)
            read -p "Enter start time (yyyy-mm-dd hh:mm:ss): " start_time
            read -p "Enter end time (yyyy-mm-dd hh:mm:ss): " end_time
            ./show_time_range.sh -t "$start_time" "$end_time"
            ;;
        6)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Enter a number between 1 and 6."
            ;;
    esac

    read -p "Do you want to continue? (y/n): " continue_choice
    if [[ "$continue_choice" != "y" ]]; then
        echo "Exiting."
        exit 0
    fi
done
