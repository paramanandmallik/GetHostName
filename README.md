# EC2 Hostname Fetcher Script

This script is designed to fetch the custom hostnames from the /etc/hosts file on Linux EC2 instances and from the C:\Windows\System32\drivers\etc\hosts file on Windows EC2 instances. 
It uses a property file to specify the IP addresses and the corresponding operating system for each EC2 instance.

## Prerequisites
SSH Access: Ensure you have SSH access to the Linux instances and the private key for authentication.
PowerShell Access: Ensure you have PowerShell installed and configured on your jumpbox for querying Windows instances.
Credential Setup: For Windows instances, PowerShell will prompt for the credentials used to connect to the EC2 instances.

## Setup

1. Property File (servers.properties)
Create a property file named servers.properties in the same directory as the script. This file contains the IP addresses of your EC2 instances and the corresponding operating system type (linux or windows). Example format:

10.0.1.10=linux
10.0.1.11=linux
10.0.1.12=linux
10.0.1.20=windows
10.0.1.21=windows

2. Script Configuration
Update the script with the path to your private key for SSH connections to Linux instances. This can be done by modifying the key_path variable:

bash
key_path="~/.ssh/your-key.pem"
Ensure the key has proper access permissions:

bash
chmod 400 ~/.ssh/your-key.pem
3. Script Permissions
Make the script executable:

bash
chmod +x get_hostnames.sh


## Usage
Run the script from your jumpbox with sudo or with an account that has sufficient permissions to read the hosts files on the remote instances:


bash
sudo ./get_hostnames.sh


The script will:

Read the servers.properties file to get the list of EC2 instance IP addresses and their OS types.
Query Linux instances via SSH to fetch hostnames from /etc/hosts.
Query Windows instances using PowerShell to fetch hostnames from C:\Windows\System32\drivers\etc\hosts.
