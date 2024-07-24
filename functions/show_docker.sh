#!/bin/bash

# Function to list all Docker images and containers
function list_docker() {
    echo "+------------------+------------------+------------------+"
    echo "| Docker Images    |                  |                  |"
    echo "+------------------+------------------+------------------+"
    echo "| Repository        | Tag              | Image ID         |"
    echo "+------------------+------------------+------------------+"

    # List Docker images
    sudo docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}" | awk 'NR > 1 {print "| " $0 " |"}'

    echo "+------------------+------------------+------------------+"
    echo "| Docker Containers|                  |                  |"
    echo "+------------------+------------------+------------------+"
    echo "| Container Name    | Status           | Image            |"
    echo "+------------------+------------------+------------------+"

    # List Docker containers
    sudo docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" | awk 'NR > 1 {print "| " $0 " |"}'

    echo "+------------------+------------------+------------------+"
}

# Function to display detailed information about a specific container
function show_container_details() {
    local container_name="$1"
    
    # Check if the container exists
    if sudo docker ps -a --format '{{.Names}}' | grep -q "^$container_name$"; then
        echo "+------------------+------------------+------------------+"
        echo "| Container Name   | State            | Config           |"
        echo "+------------------+------------------+------------------+"
        
        # Fetch and display container state
        state=$(sudo docker inspect --format '{{.State.Status}}' "$container_name")
        
        # Fetch and display container config
        config=$(sudo docker inspect --format '{{.Config.Image}}' "$container_name")
        
        # Print details in table format
        printf "| %-16s | %-16s | %-16s |\n" "$container_name" "$state" "$config"
        
        echo "+------------------+------------------+------------------+"
    else
        echo "Container '$container_name' does not exist."
    fi
}

# Function to display help message
function display_help() {
    echo "Usage: ./show_docker.sh [option] [container_name]"
    echo
    echo "Options:"
    echo "  -d, --docker           List all Docker images and containers"
    echo "  -d <container_name>    Display detailed information about a specific container"
    echo "  -h, --help             Display this help message"
    echo
    echo "Examples:"
    echo "  ./show_docker.sh -d"
    echo "  ./show_docker.sh --docker"
    echo "  ./show_docker.sh -d <container_name>"
    echo "  ./show_docker.sh -h or --help"
}

# Check for help option
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Check if the argument is provided
if [[ "$1" == "-d" || "$1" == "--docker" ]]; then
    if [[ -n "$2" ]]; then
        # Display detailed information about a specific container
        container_name="$2"
        show_container_details "$container_name"
    else
        # List all Docker images and containers
        list_docker
    fi
else
    echo "Invalid option. Use -d or --docker to list all Docker images and containers or -d <container_name> to display detailed information about a specific container."
    echo "Use -h or --help to display usage information."
fi
