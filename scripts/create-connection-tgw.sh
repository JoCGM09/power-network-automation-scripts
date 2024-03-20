#!/bin/bash
if [ -f ../.env ]; then
  source ../.env
fi

# login validation
ibmcloud login --apikey $IBM_CLOUD_API_KEY -q

#########################  Script 7: Create Transit Gateway Connection  ##########################  

# Get Cloud Connection Direct Link Gateway ID
direct_links_output=$(ibmcloud dl gateways)
dl_gateway_id=$(echo "$direct_links_output" | awk -v name="cc_wdc" '$0 ~ name {print $1}')

# Get CC Direct Link Virtual Connection Network ID
virtual_connections_output=$(ibmcloud dl virtual-connections "$dl_gateway_id")
network_id=$(echo "$virtual_connections_output" | awk -v connection="cc_wdc" '$0 ~ connection {print $5}')

# Obtener el ID del gateway usando awk y almacenarlo en la variable gateway_id
gateway_id=$(ibmcloud tg gateways | awk -v name="$IBM_CLOUD_TGW_NAME" '$0 ~ name {getline; getline; getline; print $2}')

# Verificar si se encontró un ID para el gateway
if [ -n "$gateway_id" ]; then
    echo "The ID of the gateway $IBM_CLOUD_TGW_NAME is: $gateway_id"
else
    echo "Gateway $IBM_CLOUD_TGW_NAME not found"
fi

# Network type validation 
declare -a valid_network=("classic" "vpc" "directlink" "power_virtual_server")
if [[ ! " ${valid_network[@]} " =~ " $IBM_CLOUD_TGW_NET_TYPE " ]]; then
    echo "Error: Speed connection is not valid. Use one of the following options: ${valid_network[@]}"
    exit 1
fi

ibmcloud tg connection-create $gateway_id --name $IBM_CLOUD_TGW_CON_NAME --network-type $IBM_CLOUD_TGW_NET_TYPE --network-id $network_

gateway_id=$(ibmcloud tg gateways | awk '
    {
        if ($1 == "GatewayID") {
            gateway_id = $2;  # Almacenar el GatewayID
            getline;
            getline;
            if ($2 == "test-power-vs") {
                print gateway_id;
            }
        }
    }
')

gateway_crn=$(ibmcloud tg gateways | awk '
    {
        if ($1 == "CRN") {
            crn = $2;  # Almacenar el CRN
            getline;
            if ($2 == "test-power-vs") {
                print crn;
            }
        }
    }
')
