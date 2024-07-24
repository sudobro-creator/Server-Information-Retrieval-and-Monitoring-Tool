#!/bin/bash

# Install necessary packages
function install_dependencies() {
    sudo apt update
    sudo apt install -y net-tools docker.io nginx
}

# Set up systemd service
function setup_service() {
    sudo tee /etc/systemd/system/devopsfetch.service <<EOF
[Unit]
Description=DevOps Fetch Service
After=network.target

[Service]
ExecStart=/path/to/devopsfetch.sh --port
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd and start the service
    sudo systemctl daemon-reload
    sudo systemctl enable devopsfetch.service
    sudo systemctl start devopsfetch.service
}

# Set up log rotation
function setup_log_rotation() {
    sudo tee /etc/logrotate.d/devopsfetch <<EOF
/var/log/devopsfetch.log {
    rotate 7
    daily
    compress
    missingok
    notifempty
}
EOF
}

install_dependencies
setup_service
setup_log_rotation

echo "Installation and setup complete."
