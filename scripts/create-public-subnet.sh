#!/bin/bash
if [ -f ../.env ]; then
  source ../.env
fi

# login validation
ibmcloud login --apikey $IBM_CLOUD_API_KEY -q

# Power Workspace target
service_list_output=$(ibmcloud pi service-list)
service_crn=$(echo "$service_list_output" | awk -v workspace="$IBM_POWER_WORKSPACE_NAME" '$0 ~ workspace {print $1}')
ibmcloud pi service-target "$service_crn"

#########################  Script 2: Create public subnet  ##########################    

# Subnet Target
existing_subnet=""
subnets_output=$(ibmcloud pi networks --long)
existing_subnet=$(echo "$subnets_output" | awk -v subnet="$IBM_POWER_SUBNET_NAME" '$2 == subnet {print $2}')


if [ -n "$existing_subnet" ]; then
  echo "Subnet '$existing_subnet' already exists."
else
  echo "Creating subnet..."
  if [ -n "$IBM_POWER_MTU" ]; then
    if ibmcloud pi network-create-public "$IBM_POWER_SUBNET_NAME" --mtu "$IBM_POWER_MTU"; then
    else
      echo "Error: Unable to create subnet."
    fi
  else
    if ibmcloud pi network-create-public "$IBM_POWER_SUBNET_NAME"; then
      echo "Subnet created with default MTU (1450)."
    else
      echo "Error: Unable to create subnet."
    fi
  fi
fi









ibmcloud pi network-create-public NETWORK_NAME [--jumbo] [--mtu]



ibmcloud logout