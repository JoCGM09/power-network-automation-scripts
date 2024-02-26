## Install IBM Cloud CLI:
- From Windows: 
    ```
    iex (New-Object Net.WebClient).DownloadString('https://clis.cloud.ibm.com/install/powershell')
    ```
- From Linux: 
    ```
    curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
    ```
- From Mac:
    ```
    curl -fsSL https://clis.cloud.ibm.com/install/osx | sh
    ```
## Install Plugins:
- Plugin de PowerVS:
    ```
    ibmcloud plugin install power-iaas
    ```

- Plugin de VPC:
    ```
    ibmcloud plugin install vpc-infrastructure
    ```

## Give execution permissions to the scripts folder where the .sh files are located:
```
cd power-network-automation-scripts
chmod +x scripts/*.sh
```

## Script 1: Create private subnet

 This script creates a subnet in a PowerVS Workspace if the name does not exist or a subnet with the same CIDR does not exist.

### Parameters:

    - Private subnet name
    - CIDR Block
    - IP range
    - Power Gateway
    - MTU (optional) 1450 by default 

### Environment variables for .env file:

| Variable Name             | Description                                                    | Type   | Example                     | Use Case |
|---------------------------|----------------------------------------------------------------|--------|-----------------------------|----------|
| $IBM_CLOUD_API_KEY        | API key with write permissions in PowerVS                      | String | "my_ibm_api_key"            | Required |
| $IBM_POWER_WORKSPACE_NAME | IBM PowerVS Workspace Name                                      | String | "my_workspace"              | Required |
| $IBM_POWER_SUBNET_NAME    | Desired name for the subnet to be created                      | String | "my-private-subnet"         | Required |
| $IBM_POWER_CIDR           | Valid CIDR for subnet creation                                  | String | "192.168.5.0/24"            | Required |
| $IBM_POWER_IP_RANGE       | Range of valid IPs according to the CIDR. Excluding first and last IP | String | "192.168.5.2-192.168.5.254" | Required |
| $IBM_POWER_GATEWAY        | Gateway IP. First valid IP of the CIDR                         | String | "192.168.5.1"               | Required |
| $IBM_POWER_MTU            | MTU for the subnet. Default is 1450                             | String | "1500"                      | Optional |

## Script 2: Create public subnet

 This script creates a public subnet in a PowerVS Workspace if the name does not exist.

### Parameters:

    - Private subnet name
    - CIDR Block
    - IP range
    - Power Gateway
    - MTU (optional) 1450 by default

### Environment variables for .env file:     

| variable name             | description                                  | type   | example             | use case |
|---------------------------|----------------------------------------------|--------|---------------------|----------|
| $IBM_CLOUD_API_KEY        | API key con permisos de escritura en PowerVS | string | "my_ibm_api_key"    | required |
| $IBM_POWER_WORKSPACE_NAME | IBM PowerVS Workspace Name                   | string | "my_workspace"      | required |
| $IBM_POWER_SUBNET_NAME    | Nombre deseado para la subred por crear      | string | "my-private-subnet" | required |
| $IBM_POWER_MTU            | MTU para la subred. 1450 por defecto         | string | "1500"              | optional |