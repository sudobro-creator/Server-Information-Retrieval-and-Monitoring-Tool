#!/bin/bash

# Function to display all users and their last login times in a table format
function list_all_users() {
    echo "+------------------+------------------+------------------+"
    echo "| Username         | Last Login Date  | Last Login Time  |"
    echo "+------------------+------------------+------------------+"
    who | awk '{print $1, $3, $4}' | sort | uniq | while read -r user date time; do
        # Format the date and time for output
        printf "| %-16s | %-16s | %-16s |\n" "$user" "$date" "$time"
    done
    echo "+------------------+------------------+------------------+"
}

# Function to display detailed information about a specific user
function show_user_details() {
    local username="$1"
    echo "+------------------+------------------+------------------+------------------+------------------+-----------------------------------+"
    echo "| Username         | Login Time       | Idle Time        | JCPU             | PCPU             | Current Process                   |"
    echo "+------------------+------------------+------------------+------------------+------------------+-----------------------------------+"
    
    # Use `w` to get detailed information about the user
    user_info=$(w -h "$username")
    
    if [[ -n "$user_info" ]]; then
        login_time=$(echo "$user_info" | awk '{print $4, $5}')
        idle_time=$(echo "$user_info" | awk '{print $6}')
        jcpu=$(echo "$user_info" | awk '{print $7}')
        pcpu=$(echo "$user_info" | awk '{print $8}')
        current_process=$(echo "$user_info" | awk '{print substr($0, index($0,$9))}')
        
        # Print in table format
        printf "| %-16s | %-16s | %-16s | %-16s | %-16s | %-16s |\n" "$username" "$login_time" "$idle_time" "$jcpu" "$pcpu" "$current_process"
    else
        echo "No information available for user: $username"
    fi
    
    echo "+------------------+------------------+------------------+------------------+------------------+-----------------------------------+"
}

# Function to display help message
function display_help() {
    echo "Usage: ./show_users.sh [option] [username]"
    echo
    echo "Options:"
    echo "  -u, --users        List all users and their last login times"
    echo "  -u <username>      Display detailed information about a specific user"
    echo "  -h, --help         Display this help message"
    echo
    echo "Examples:"
    echo "  ./show_users.sh -u"
    echo "  ./show_users.sh --users"
    echo "  ./show_users.sh -u <username>"
    echo "  ./show_users.sh -h or --help"
}

# Check for help option
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Check if the argument is provided
if [[ "$1" == "-u" || "$1" == "--users" ]]; then
    if [[ -n "$2" ]]; then
        # Display detailed information about a specific user
        username="$2"
        echo "Detailed information for user: $username"
        show_user_details "$username"
    else
        # List all users and their last login times
        echo "Listing all users and their last login times:"
        list_all_users
    fi
else
    echo "Invalid option. Use -u or --users to list all users or -u <username> to display detailed information about a specific user."
    echo "Use -h or --help to display usage information."
fi
