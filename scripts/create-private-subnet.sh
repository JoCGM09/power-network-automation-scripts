#!/bin/bash
#if [ -f ../.env ]; then
#  source ../.env
#fi

# login validation
ibmcloud login --apikey $IBM_CLOUD_API_KEY -q

# Power Workspace target
service_list_output=$(ibmcloud pi service-list)
service_crn=$(echo "$service_list_output" | awk -v workspace="$IBM_POWER_WORKSPACE_NAME" '$0 ~ workspace {print $1}')
ibmcloud pi service-target "$service_crn"

#########################  Script 1: Create private subnet  ##########################    

existing_subnet=""
subnets_output=$(ibmcloud pi subnet list)
existing_subnet=$(echo "$subnets_output" | awk -v subnet="$IBM_POWER_SUBNET_NAME" '$2 == subnet {print $1}')

existing_cidr=""
existing_cidr=$(echo ibmcloud pi subnet get "$subnet_id" | awk -F ' ' '/CIDR Block/ {print $NF}')

if [ -n "$existing_subnet" ]; then
  echo "Subnet '$existing_subnet' still exists."
  exit 1
elif [ -n "$existing_cidr" ]; then
  echo "CIDR ($existing_cidr) already exists."
  exit 1
else
  echo "Creating subnet..."
  if [ -n "$IBM_POWER_MTU" ]; then
    if ibmcloud pi subnet create "$IBM_POWER_SUBNET_NAME" --cidr-block "$IBM_POWER_CIDR" --net-type private --ip-range "$IBM_POWER_IP_RANGE" --gateway "$IBM_POWER_GATEWAY" --mtu "$IBM_POWER_MTU"; then
      echo "Subnet created with MTU: $IBM_POWER_MTU."
    else
      echo "Error: Unable to create subnet."
      
    fi
  else
    if  ibmcloud pi subnet create "$IBM_POWER_SUBNET_NAME" --cidr-block "$IBM_POWER_CIDR" --net-type private --ip-range "$IBM_POWER_IP_RANGE" --gateway "$IBM_POWER_GATEWAY"; then
      echo "Subnet created with default MTU (1450)."
    else
      echo "Error: Unable to create subnet."
      exit 1
    fi
  fi
fi
ibmcloud logout