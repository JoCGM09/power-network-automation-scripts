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

#########################  Script 4: Attach subnet  #########################   

# Instance target
instance_crn=""

instances_list_output=$(ibmcloud pi instances)
instance_crn=$(echo "$instances_list_output" | awk -v instances=$IBM_POWER_INSTANCE_NAME '$2 == instances {print $1}')

#Subnet ID target
subnet_id=""

subnets_output=$(ibmcloud pi networks --long)
subnet_id=$(echo "$subnets_output" | awk -v subnet="$IBM_POWER_SUBNET_NAME" '$2 == subnet {print $1}')

if [ -n "$instance_crn" ] && [ -n "$subnet_id" ]; then
  connection_flags=""
  if [[ "$AUTO_ASSIGN_IP" == "true" ]]; then
    connection_flags+="--auto-assign-ip "
  else
    connection_flags+="--ip-address $IBM_INSTANCE_ATTACH_IP "
  fi

  echo "Attaching subnet into LPAR..."
  ibmcloud pi instance-attach-network "$IBM_POWER_INSTANCE_NAME" --network "$subnet_id" $connection_flags
  echo "Subnet attached into LPAR."
elif [ -n "$instance_crn" ]; then
  echo "Subnet ($IBM_POWER_SUBNET_NAME) doesn't exist."
elif [ -n "$subnet_id" ]; then
  echo "LPAR instance ($IBM_POWER_INSTANCE_NAME) doesn't exist."
fi


ibmcloud logout
