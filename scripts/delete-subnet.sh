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

#########################  Script 3: Delete private subnet  ##########################   

existing_subnet_crn=""

subnets_output=$(ibmcloud pi networks --long)
existing_subnet_crn=$(echo "$subnets_output" | awk -v subnet="$IBM_POWER_SUBNET_NAME" '$2 == subnet {print $1}')

if [ -n "$existing_subnet_crn" ]; then
  if ibmcloud pi network-delete "$existing_subnet_crn"; then
    echo "Subnet deleted successfully."
  else
    echo "Error: Unable to delete subnet."
  fi
else
  echo "Subnet does not exist."
fi

ibmcloud logout