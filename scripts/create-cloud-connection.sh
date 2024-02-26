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

#########################  Script 6: Create cloud connection  ##########################    

# Speed validation 
declare -a valid_speeds=("50" "100" "200" "500" "1000" "2000" "5000" "10000")
if [[ ! " ${valid_speeds[@]} " =~ " $IBM_POWER_CC_SPEED " ]]; then
    echo "Error: Speed value is not valid. Use one of the following options: ${valid_speeds[@]}"
    exit 1
fi

subnet_id=""

subnets_output=$(ibmcloud pi networks --long)
subnet_id=$(echo "$subnets_output" | awk -v subnet="$IBM_POWER_SUBNET_NAME" '$2 == subnet {print $1}')

vpc_id=""

vpcs_output=$(ibmcloud is vpcs -q)
vpc_id=$(echo "$vpcs_output" | awk -v vpc="$IBM_VPC_NAME" '$2 == vpc {print $1}')

# Flags validations

# Global routing option
if [[ "$IBM_POWER_CC_GR_ENABLED" == "true" ]]; then
    global_routing_flag="--global-routing"
else
    global_routing_flag=""
fi

connection_flags=""

# Transit Gateway connection
if [[ "$USE_TRANSIT" == "true" ]]; then
    connection_flags+="--transit-enabled "
fi

# Classic or GRE connections
if [[ "$IBM_POWER_CC_USE_CLASSIC" == "true" ]]; then
    if [[ "$IBM_POWER_CC_USE_CLASSIC_GRE" == "true" ]]; then
        echo "Error: Only one option can be specified between classic networks or classic gre tunnel."
        exit 1
    fi
    connection_flags+="--classic --networks \"$subnet_id\" "
fi

if [[ "$IBM_POWER_CC_USE_CLASSIC_GRE" == "true" ]]; then
    connection_flags+="--classic --networks \"$subnet_id\" --gre-tunnel \"$IBM_POWER_CC_GRE_CIDR $IBM_POWER_CC_GRE_DEST_IP\" "
fi

# VPC connection
if [[ "$IBM_POWER_CC_USE_VPC" == "true" ]]; then
    connection_flags+="--vpc --vpcID \"$vpc_id\" "
fi

# Verify connections
if [[ -z "$connection_flags" ]]; then
    echo "Error: You must specify at least one connection."
    exit 1
fi

# Connection command
ibmcloud pi connection-create "$IBM_POWER_CC_NAME" --speed "$SPEED" $connection_flags $global_routing_flag