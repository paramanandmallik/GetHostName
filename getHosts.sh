#!/bin/bash

key_path="~/.ssh/your-key.pem"
property_file="servers.properties"

# Function to query Linux instances
query_linux() {
  local server=$1
  echo "Checking /etc/hosts on $server (Linux)..."
  ssh -i "$key_path" ec2-user@$server "grep -vE '^#|^127\\.0\\.0\\.1' /etc/hosts | awk '{print \$2}' | head -n 1" 2>/dev/null
  
  if [ $? -eq 0 ]; then
    echo "Hostname fetched successfully from $server."
  else
    echo "Failed to fetch hostname from $server."
  fi
  echo ""
}

# Function to query Windows instances using PowerShell from the jumpbox
query_windows() {
  local server=$1
  echo "Checking hosts file on $server (Windows)..."
  powershell -Command "
    \$cred = Get-Credential -Credential ec2-user;
    \$hostname = Invoke-Command -ComputerName $server -Credential \$cred -ScriptBlock {
      Get-Content 'C:\\Windows\\System32\\drivers\\etc\\hosts' | Where-Object {\$_ -notmatch '^#|^\s*\$' } | ForEach-Object { \$_ -split ' ' }[1];
    };
    if (\$hostname) {
      Write-Host \"Hostname fetched from $server: \$hostname\";
    } else {
      Write-Host \"Failed to fetch hostname from $server.\";
    }
  "
}

# Function to process the property file and fetch hostnames
process_servers() {
  while IFS='=' read -r server os_type; do
    if [ "$os_type" == "linux" ]; then
      query_linux "$server"
    elif [ "$os_type" == "windows" ]; then
      query_windows "$server"
    else
      echo "Unknown OS type for $server. Skipping..."
    fi
  done < "$property_file"
}

# Call the process_servers function
process_servers

