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

#########################  Script 6: Delete cloud connection  ##########################

connection_crn=""

connections_output=$(ibmcloud pi connections)
connection_crn=$(echo "$connections_output" | awk -v connection="$IBM_POWER_CC_NAME" '$2 == connection {print $1}')

if [ -n "$connection_crn" ]; then
  if ibmcloud pi connection-delete "$connection_crn"; then
    echo "Cloud Connection deleted successfully."
  else
    echo "Error: Unable to delete cloud connection."
  fi
else
  echo "Cloud Connection does not exist."
fi

ibmcloud logout