#!/bin/bash

# Function to display activities within a specified time range
function show_time_range() {
    local start_time="$1"
    local end_time="$2"
    
    echo "+---------------------+---------------------+"
    echo "| Timestamp           | Activity            |"
    echo "+---------------------+---------------------+"
    
    # Fetch log entries within the specified time range
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

# Function to display help message
function display_help() {
    echo "Usage: ./show_time_range.sh [option] [start_time] [end_time]"
    echo
    echo "Options:"
    echo "  -t, --time <start_time> <end_time>   Display activities within the specified time range"
    echo "  -h, --help                         Display this help message"
    echo
    echo "Date format: yyyy-mm-dd hh:mm:ss"
    echo
    echo "Examples:"
    echo "  ./show_time_range.sh -t \"2024-07-01 00:00:00\" \"2024-07-01 23:59:59\""
    echo "  ./show_time_range.sh --time \"2024-07-01 00:00:00\" \"2024-07-01 23:59:59\""
    echo "  ./show_time_range.sh -h or --help"
}

# Check for help option
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Check for time range option
if [[ "$1" == "-t" || "$1" == "--time" ]]; then
    if [[ -n "$2" && -n "$3" ]]; then
        # Display activities within the specified time range
        start_time="$2"
        end_time="$3"
        show_time_range "$start_time" "$end_time"
    else
        echo "Error: Missing start time or end time."
        display_help
    fi
else
    # No arguments or invalid option, no output
    exit 0
fi
