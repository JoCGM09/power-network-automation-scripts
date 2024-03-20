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

- Plugin de Transit Gateway:
    ```
    ibmcloud plugin install tg
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
| IBM_CLOUD_API_KEY        | API key with write permissions in PowerVS                      | String | "my_ibm_api_key"            | Required |
| IBM_POWER_WORKSPACE_NAME | IBM PowerVS Workspace Name                                      | String | "my_workspace"              | Required |
| IBM_POWER_SUBNET_NAME    | Desired name for the subnet to be created                      | String | "my-private-subnet"         | Required |
| IBM_POWER_CIDR           | Valid CIDR for subnet creation                                  | String | "192.168.5.0/24"            | Required |
| IBM_POWER_IP_RANGE       | Range of valid IPs according to the CIDR. First and last IP | String | "192.168.5.2-192.168.5.254" | Required |
| IBM_POWER_GATEWAY        | Gateway IP. First valid IP of the CIDR                         | String | "192.168.5.1"               | Required |
| IBM_POWER_MTU            | MTU for the subnet. Default is 1450                             | String | "1500"                      | Optional |

## Script 2: Create public subnet

 This script creates a public subnet in a PowerVS Workspace if the name does not exist.

### Parameters:

- Public subnet name
- MTU (optional) 1450 by default

### Environment variables for .env file:     

| Variable Name             | Description                                  | Type   | Example             | Use Case |
|---------------------------|----------------------------------------------|--------|---------------------|----------|
| IBM_CLOUD_API_KEY        | API key with write permissions in PowerVS    | String | "my_ibm_api_key"    | Required |
| IBM_POWER_WORKSPACE_NAME | IBM PowerVS Workspace Name                   | String | "my_workspace"      | Required |
| IBM_POWER_SUBNET_NAME    | Desired name for the subnet to be created    | String | "my-private-subnet" | Required |
| IBM_POWER_MTU            | MTU for the subnet. Default is 1450          | String | "1500"              | Optional |


## Script 3: Delete subnet

 This script deletes a subnet in a PowerVS Workspace if the name does exist.

### Parameters:

- Subnet CRN

### Environment variables for .env file:     

| Variable Name             | Description                                  | Type   | Example             | Use Case |
|---------------------------|----------------------------------------------|--------|---------------------|----------|
| IBM_CLOUD_API_KEY        | API key with write permissions in PowerVS    | String | "my_ibm_api_key"    | Required |
| IBM_POWER_WORKSPACE_NAME | IBM PowerVS Workspace Name                   | String | "my_workspace"      | Required |
| IBM_POWER_SUBNET_NAME    | Desired name for the subnet to be created    | String | "my-private-subnet" | Required |

## Script 4: Attach subnet

 This script attact a subnet into an LPAR if both exists.

### Parameters:

- LPAR instance name
- Subnet CRN
- IP address (optional) random assign by default

### Environment variables for .env file:     

| Variable Name            | Description                                     | Type    | Example             | Use Case |
|--------------------------|-------------------------------------------------|---------|---------------------|----------|
| IBM_CLOUD_API_KEY        | API key with write permissions in PowerVS       | String  | "my_ibm_api_key"    | Required |
| IBM_POWER_WORKSPACE_NAME | IBM PowerVS Workspace Name                      | String  | "my_workspace"      | Required |
| IBM_POWER_SUBNET_NAME    | Desired name for the subnet to be created       | String  | "my-private-subnet" | Required |
| IBM_POWER_INSTANCE_NAME  | LPAR instance name                              | String  | "my-lpar-aix"       | Required |
| AUTO_ASSIGN_IP           | Determinate if there is an auto assign IP or not| Boolean | true                | Required |
| IBM_INSTANCE_ATTACH_IP   | IP to attach into the LPAR instance             | String  | "my-lpar-aix"       | Optional |

## Script 5: Detach subnet

 This script detach a subnet from an LPAR if both exists.

### Parameters:

- LPAR instance name
- Subnet CRN

### Environment variables for .env file:     

| Variable Name            | Description                                     | Type    | Example             | Use Case |
|--------------------------|-------------------------------------------------|---------|---------------------|----------|
| IBM_CLOUD_API_KEY        | API key with write permissions in PowerVS       | String  | "my_ibm_api_key"    | Required |
| IBM_POWER_WORKSPACE_NAME | IBM PowerVS Workspace Name                      | String  | "my_workspace"      | Required |
| IBM_POWER_SUBNET_NAME    | Desired name for the subnet to be created       | String  | "my-private-subnet" | Required |
| IBM_POWER_INSTANCE_NAME  | LPAR instance name                              | String  | "my-lpar-aix"       | Required |

## Script 6: Create cloud connection

This script creates a cloud connection into a transit gateway, Classic with or without GRE tunnel and/or VPC connection
### Parameters:

- LPAR instance name
- Subnet CRN

### Environment variables for .env file:     

| Variable Name              | Description                                     | Type   | Example                         | Use Case |
|----------------------------|-------------------------------------------------|--------|---------------------------------|----------|
| IBM_CLOUD_API_KEY          | API key with write permissions in PowerVS       | String | "my_ibm_api_key"               | Required |
| IBM_POWER_WORKSPACE_NAME   | Name of the IBM PowerVS Workspace               | String | "my_workspace"                 | Required |
| IBM_POWER_SUBNET_NAME      | Desired name for the subnet to be created       | String | "my-private-subnet"            | Required |
| IBM_POWER_CC_SPEED         | Speed of the cloud connection (50, 100, 200, 500, 1000, 2000, 5000, 10000)| String | "1000"                          | Required |
| IBM_VPC_NAME               | Name of the IBM Cloud VPC                       | String | "my_vpc"                       | Optional |
| IBM_POWER_CC_GR_ENABLED    | Indicates if global routing is enabled          | String | true              | Optional |
| USE_TRANSIT                | Indicates if transit gateway is enabled         | String | true             | Optional |
| IBM_POWER_CC_USE_CLASSIC   | Indicates if classic connection is used         | String | true             | Optional |
| IBM_POWER_CC_USE_CLASSIC_GRE | Indicates if classic connection with GRE tunnel is used | String | false        | Optional |
| IBM_POWER_CC_GRE_CIDR      | CIDR for the GRE tunnel in the classic connection | String | "203.0.113.0/28"              | Optional |
| IBM_POWER_CC_GRE_DEST_IP   | Destination IP for the GRE tunnel               | String | "203.0.113.1"                  | Optional |
| IBM_POWER_CC_USE_VPC       | Indicates if VPC connection is used             | String | "true" or "false"              | Optional |
| IBM_VPC_NAME               | Name of the IBM VPC used              | String | "my_vpc"                 | Optional |



