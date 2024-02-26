## Instalar CLI de IBM Cloud:
    Desde Windows: 
        iex (New-Object Net.WebClient).DownloadString('https://clis.cloud.ibm.com/install/powershell')
    Desde Linux: 
        curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
    Desde Mac:
        curl -fsSL https://clis.cloud.ibm.com/install/osx | sh

## Comandos para descargar los plugins de IBM Cloud CLI:
    Plugin de PowerVS:
        ibmcloud plugin install power-iaas
    Plugin de Transit Gateway:

    Plugin de VPC:
        ibmcloud plugin install vpc-infrastructure

## Dar permisos de ejecución a la carpeta scripts donde están los archivos .sh:
    cd power-bash-scripts
    chmod +x scripts/*.sh

## Crear archivo .env
Variables de entorno: 
    IBM_CLOUD_API_KEY= IAM API Key con permisos de creación de PowerVS y Transit Gateway
    IBM_POWER_WORKSPACE_NAME= Nombre del Workspace de PowerVS
    IBM_POWER_SUBNET_NAME= Nombre de la subred privada
    IBM_POWER_CIDR= CIDR asignado para la subred privada ej: "192.168.5.0/24"
    IBM_POWER_IP_RANGE= Rango de IPs dentro del cidr utilizables ej: "192.168.5.2-192.168.5.254"
    IBM_POWER_GATEWAY= IP del Power Gateway, primera IP del CIDR ej: "192.168.5.1"
    IBM_POWER_INSTANCE_NAME= Nombre de una instancia LPAR
    IBM_INSTANCE_ATTACH_IP= IP específica para vincular un LPAR a una subred
    AUTO_ASSIGN_IP= Booleano para validar la asignación de una IP automática ej: true para asignación automática




