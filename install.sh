#!/bin/bash

# Install necessary packages
function install_dependencies() {
    sudo apt update
    sudo apt install -y net-tools docker.io nginx jq
}

function copy_script() {
    cp devopsfetch.sh /usr/local/bin/devopsfetch
    chmod +x /usr/local/bin/devopsfetch
}


# Set up systemd service
function setup_service() {
    sudo tee /etc/systemd/system/devopsfetch.service <<EOF
[Unit]
Description=DevOps Fetch Service
After=network.target

[Service]
ExecStart=/usr/local/bin/devopsfetch -t now now
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start the service
systemctl daemon-reload
systemctl enable devopsfetch.service
systemctl start devopsfetch.service
}

# Set up log rotation
function setup_log_rotation() {
    sudo tee /etc/logrotate.d/devopsfetch <<EOF
/var/log/devopsfetch.log {
    daily
    rotate 7
    compress
    missingok
    notifempty
    create 0640 root root
    postrotate
        systemctl reload devopsfetch.service > /dev/null 2>/dev/null || true
    endscript
}
EOF
}

install_dependencies
copy_script
setup_service
setup_log_rotation

echo "Yessss, Installation is now complete. Now start your devopsfetch."
