#!/bin/bash

# Function to list all Nginx server configurations
function list_nginx_servers() {
    echo "+------------------+------------------+--------------------------+"
    echo "| Server Name      | Proxy Pass       | Config File Path         |"
    echo "+------------------+------------------+--------------------------+"
    
    # Find all Nginx configuration files and process them
    for conf_file in $(sudo find /etc/nginx -name '*.conf'); do
        # Extract server_name and proxy_pass from the config file
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

    # Find the configuration file containing the specified domain
    conf_file=$(sudo grep -rl "server_name\s*$domain" /etc/nginx)

    if [[ -n "$conf_file" ]]; then
        echo "+------------------+-----------------------------------+"
        echo "| Config File Path | Detailed Configuration            |"
        echo "+------------------+-----------------------------------+"
        
        # Display the entire configuration file content
        sudo awk '{printf "| %-18s | %-35s |\n", " ", $0}' "$conf_file"
        
        echo "+------------------+-----------------------------------+"
    else
        echo "Domain '$domain' not found in any configuration file."
    fi
}

# Function to display help message
function display_help() {
    echo "Usage: ./show_nginx.sh [option] [domain]"
    echo
    echo "Options:"
    echo "  -n, --nginx           List all Nginx server names, proxy pass values, and config file paths"
    echo "  -n <domain>           Display detailed configuration for a specific server name"
    echo "  -h, --help            Display this help message"
    echo
    echo "Examples:"
    echo "  ./show_nginx.sh -n"
    echo "  ./show_nginx.sh --nginx"
    echo "  ./show_nginx.sh -n <domain>"
    echo "  ./show_nginx.sh -h or --help"
}

# Check for help option
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Check if the argument is provided
if [[ "$1" == "-n" || "$1" == "--nginx" ]]; then
    if [[ -n "$2" ]]; then
        # Display detailed information for a specific domain
        domain="$2"
        show_domain_details "$domain"
    else
        # List all Nginx server names and proxy pass values
        list_nginx_servers
    fi
else
    # If no argument is provided or the option is invalid, show an error message and help
    echo "Error: No arguments provided or invalid option."
    echo
    display_help
fi
