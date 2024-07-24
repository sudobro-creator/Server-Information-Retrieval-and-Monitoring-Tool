#!/bin/bash

# Function to list all users and their last login times
function list_all_users() {
    echo "+------------------+------------------+------------------+"
    echo "| Username         | Last Login Date  | Last Login Time  |"
    echo "+------------------+------------------+------------------+"
    who | awk '{print $1, $3, $4}' | sort | uniq | while read -r user date time; do
        printf "| %-16s | %-16s | %-16s |\n" "$user" "$date" "$time"
    done
    echo "+------------------+------------------+------------------+"
}

# Function to show detailed information about a specific user
function show_user_details() {
    local username="$1"
    echo "+------------------+------------------+------------------+------------------+------------------+-----------------------------------+"
    echo "| Username         | Login Time       | Idle Time        | JCPU             | PCPU             | Current Process                   |"
    echo "+------------------+------------------+------------------+------------------+------------------+-----------------------------------+"
    
    user_info=$(w -h "$username")
    
    if [[ -n "$user_info" ]]; then
        login_time=$(echo "$user_info" | awk '{print $4, $5}')
        idle_time=$(echo "$user_info" | awk '{print $6}')
        jcpu=$(echo "$user_info" | awk '{print $7}')
        pcpu=$(echo "$user_info" | awk '{print $8}')
        current_process=$(echo "$user_info" | awk '{print substr($0, index($0,$9))}')
        
        printf "| %-16s | %-16s | %-16s | %-16s | %-16s | %-16s |\n" "$username" "$login_time" "$idle_time" "$jcpu" "$pcpu" "$current_process"
    else
        echo "No information available for user: $username"
    fi
    
    echo "+------------------+------------------+------------------+------------------+------------------+-----------------------------------+"
}

# Function to show activities within a specified time range
function show_time_range() {
    local start_time="$1"
    local end_time="$2"
    
    echo "+---------------------+---------------------+"
    echo "| Timestamp           | Activity            |"
    echo "+---------------------+---------------------+"
    
    sudo journalctl --since "$start_time" --until "$end_time" --no-pager | awk '
    /-- Logs begin/ {next}
    /-- No entries/ {exit}
    {
        timestamp = substr($0, 1, 15)
        activity = substr($0, 17)
        if (length(activity) > 50) activity = substr(activity, 1, 50) "..."
        printf "| %-19s | %-19s |\n", timestamp, activity
    }
    '
    
    echo "+---------------------+---------------------+"
}

# Function to display active ports and services
function show_ports() {
    if [[ -n "$1" ]]; then
        sudo netstat -tuln | grep "$1"
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
}

# Function to list all Nginx server configurations
function list_nginx_servers() {
    echo "+------------------+------------------+--------------------------+"
    echo "| Server Name      | Proxy Pass       | Config File Path         |"
    echo "+------------------+------------------+--------------------------+"
    
    for conf_file in $(sudo find /etc/nginx -name '*.conf'); do
        sudo grep -E 'server_name|proxy_pass' "$conf_file" | awk -v conf="$conf_file" '
        /server_name/ {
            server_name=$2
        }
        /proxy_pass/ {
            proxy_pass=$2
            printf "| %-16s | %-16s | %-26s |\n", server_name, proxy_pass, conf
        }'
    done

    echo "+------------------+------------------+--------------------------+"
}

# Function to display detailed configuration information for a specific domain
function show_domain_details() {
    local domain="$1"

    conf_file=$(sudo grep -rl "server_name\s*$domain" /etc/nginx)

    if [[ -n "$conf_file" ]]; then
        echo "+------------------+-----------------------------------+"
        echo "| Config File Path | Detailed Configuration            |"
        echo "+------------------+-----------------------------------+"
        
        sudo awk '{printf "| %-18s | %-35s |\n", " ", $0}' "$conf_file"
        
        echo "+------------------+-----------------------------------+"
    else
        echo "Domain '$domain' not found in any configuration file."
    fi
}

# Function to list all Docker images and containers
function list_docker() {
    echo "+------------------+------------------+------------------+"
    echo "| Docker Images    |                  |                  |"
    echo "+------------------+------------------+------------------+"
    echo "| Repository        | Tag              | Image ID         |"
    echo "+------------------+------------------+------------------+"

    sudo docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}" | awk 'NR > 1 {print "| " $0 " |"}'

    echo "+------------------+------------------+------------------+"
    echo "| Docker Containers|                  |                  |"
    echo "+------------------+------------------+------------------+"
    echo "| Container Name    | Status           | Image            |"
    echo "+------------------+------------------+------------------+"

    sudo docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" | awk 'NR > 1 {print "| " $0 " |"}'

    echo "+------------------+------------------+------------------+"
}

# Function to display detailed information about a specific container
function show_container_details() {
    local container_name="$1"
    
    if sudo docker ps -a --format '{{.Names}}' | grep -q "^$container_name$"; then
        echo "+------------------+------------------+------------------+"
        echo "| Container Name   | State            | Config           |"
        echo "+------------------+------------------+------------------+"
        
        state=$(sudo docker inspect --format '{{.State.Status}}' "$container_name")
        config=$(sudo docker inspect --format '{{.Config.Image}}' "$container_name")
        
        printf "| %-16s | %-16s | %-16s |\n" "$container_name" "$state" "$config"
        
        echo "+------------------+------------------+------------------+"
    else
        echo "Container '$container_name' does not exist."
    fi
}

# General help function
function display_help() {
    echo "Usage: ./script.sh [option] [arguments]"
    echo
    echo "Options:"
    echo "  -u, --users [username]           List all users and their last login times or display details for a specific user"
    echo "  -t, --time <start_time> <end_time> Display activities within the specified time range"
    echo "  -p, --port [port_number]          Display active ports or details for a specific port"
    echo "  -n, --nginx [domain]              List all Nginx server configurations or display details for a specific domain"
    echo "  -d, --docker [container_name]     List all Docker images and containers or display details for a specific container"
    echo "  -h, --help                        Display this help message"
    echo
    echo "Date format for time range: yyyy-mm-dd hh:mm:ss"
    echo
    echo "Examples:"
    echo "  ./script.sh -u"
    echo "  ./script.sh -u <username>"
    echo "  ./script.sh -t \"2024-07-01 00:00:00\" \"2024-07-01 23:59:59\""
    echo "  ./script.sh -p <port_number>"
    echo "  ./script.sh -n"
    echo "  ./script.sh -n <domain>"
    echo "  ./script.sh -d"
    echo "  ./script.sh -d <container_name>"
    echo "  ./script.sh -h"
}

# Check for help option
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Parse options and arguments
case "$1" in
    -u|--users)
        if [[ -n "$2" ]]; then
            show_user_details "$2"
        else
            list_all_users
        fi
        ;;
    -t|--time)
        if [[ -n "$2" && -n "$3" ]]; then
            show_time_range "$2" "$3"
        else
            echo "Error: Missing start time or end time."
            display_help
        fi
        ;;
    -p|--port)
        show_ports "$2"
        ;;
    -n|--nginx)
        if [[ -n "$2" ]]; then
            show_domain_details "$2"
        else
            list_nginx_servers
        fi
        ;;
    -d|--docker)
        if [[ -n "$2" ]]; then
            show_container_details "$2"
        else
            list_docker
        fi
        ;;
    *)
        echo "Error: Invalid option."
        display_help
        ;;
esac
