# Server-Information-Retrieval-and-Monitoring-Tool

<h3>HNG-Stage-Five</h3>

`devopsfetch.sh` is an information retrieval and monitoring tool written in bash that collects and displays different system and DevOps-related data. It allows you to manage user logins, view system activities, monitor ports, and handle Docker containers and Nginx configurations.

## Features

- **List All Users:** Display all users and their last login times.
- **Show User Details:** View detailed information about a specific user.
- **Show Activities:** Display system activities within a specified time range.
- **Show Ports:** List all active ports and services or details for a specific port.
- **List Nginx Servers:** List all Nginx server configurations.
- **Show Domain Details:** Display detailed configuration for a specific Nginx domain.
- **List Docker Images and Containers:** Show all Docker images and containers.
- **Show Container Details:** Provide detailed information about a specific Docker container.

## Installation

To install `install.sh` and set up the required dependencies, systemd service, and log rotation, use the `devopsfetch.sh` script.

<h3>Setup Process</h3>
- Clone the repository

```
git clone git@github.com:sudobro-creator/Server-Information-Retrieval-and-Monitoring-Tool.git
cd Server-Information-Retrieval-and-Monitoring-Tool.git
```
- Run the `install.sh` to set up dependecies and the systemd service
```
./install.sh
```


The  `install.sh` script will:
- Install necessary packages (`net-tools`, `docker.io`, `nginx`, `jq`).
- Copy `devopsfetch.sh` to `/usr/local/bin/` and make it executable.
- Set up a systemd service for continuous monitoring.
- Configure log rotation for the service.

<h3>Dependencies</h3>
Ensure the following packages are installed on your system

- `docker.io`
- `nginx`
- `jp`
- `netstat`

## How to use the tool
```
./devopsfetch.sh [option] [arguments]
```
## Help guide
To display the help message with usage instructions, run:
`./devopsfetch.sh -h` or `./devopsfetch.sh --help`

```
    -u, --users [username]
        List all users and their last login times or display details for a specific user.
    -t, --time <start_time> <end_time>
        Display activities within the specified time range.
    -p, --port [port_number]
        Display active ports or details for a specific port.
    -n, --nginx [domain]
        List all Nginx server configurations or display details for a specific domain.
    -d, --docker [container_name]
        List all Docker images and containers or display details for a specific container.
    -h, --help
        Display this help message.
```
<h3>Date Format</h3>

```
For time range: yyyy-mm-dd hh:mm:ss
```

<h4>Examples</h4>

```
# To display the help message with usage instructions
./devopsfetch.sh -h

# To list all users and their last login times
./devopsfetch.sh -u

# To provide detailed information about a specific user
./devopsfetch.sh -u <username>

# To display activities within a specified time range
./devopsfetch.sh -t "2024-07-01 00:00:00" "2024-07-01 23:59:59"

# To display all active ports and services
./devopsfetch.sh -p

# To provide detailed information about a specific port
./devopsfetch.sh -p <port_number>

# To display all Nginx domains and their ports
./devopsfetch.sh -n

# To display all Nginx domains and their ports
./devopsfetch.sh -n <domain>

# To list all Docker images and containers
./devopsfetch.sh -d

# To provide detailed information about a specific Docker container
./devopsfetch.sh -d <container_name>
```

<h3>Logging</h3>
Logs are stored in the `/var/log/devopsfetch.log` directory. Log rotation is implemented to manage log file size. Log rotation is configured to rotate logs daily, keeping up to 7 days of logs.
