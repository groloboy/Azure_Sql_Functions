# Establecer Valores de parámetros
# Set the resource group name and location for your server
resourceGroupName=myResourceGroup
location=eastus

# Set an admin login and password for your database
adminlogin=azureuser
password=Azure1234567!

# Set a server name that is unique to Azure DNS (<server_name>.database.windows.net)
serverName=server-$RANDOM

# Set the ip address range that can access your database
startip=186.80.78.133
endip=186.80.78.133

# Crear un grupo de recursos
az group create --name $resourceGroupName --location $location

# Creación de un servidor
az sql server create \
    --name $serverName \
    --resource-group $resourceGroupName \
    --location $location  \
    --admin-user $adminlogin \
    --admin-password $password

# Configuración de una regla de firewall del servidor
az sql server firewall-rule create \
    --resource-group $resourceGroupName \
    --server $serverName \
    -n AllowYourIp \
    --start-ip-address $startip \
    --end-ip-address $endip

# Crear una base de datos única
az sql db create \
    --resource-group $resourceGroupName \
    --server $serverName \
    --name mySampleDatabase \
    --sample-name AdventureWorksLT \
    --edition GeneralPurpose \
    --compute-model Serverless \
    --family Gen5 \
    --capacity 2

# Consulta de la base de datos

## PARTE 2

func init LocalFunctionProj --dotnet
cd LocalFunctionProj

func new --name HttpExample --template "HTTP trigger" --authlevel "anonymous"

## Cambiar documentos HttpExample.cs LocalFunctionProj.csproj
func start
# Conexion a base de datos, cambiar server y user id y password de ser necesario
# var str = "Server=tcp:server-5005.database.windows.net,1433;Initial Catalog=mySampleDatabase;Persist Security Info=False;User ID=azureuser;Password=Azure1234567!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=60;";


# cambiar bquinonesqlstorage y bquinonesSql
az group create --name AzureFunctionsQuickstart-rg --location eastus
az storage account create --name bquinonesqlstorage --location eastus --resource-group AzureFunctionsQuickstart-rg --sku Standard_LRS
az functionapp create --resource-group AzureFunctionsQuickstart-rg --consumption-plan-location eastus --runtime dotnet --functions-version 3 --name bquinonesSql --storage-account bquinonesqlstorage

func azure functionapp publish bquinonesSql

# ejecutar para ingresar la reglas de firewall con la ip que se muestra en el error 
func azure functionapp logstream bquinonesSql 

https://bquinonessql.azurewebsites.net/api/httpexample
https://bquinonessql.azurewebsites.net/api/httpexample?name=aaa&&newName=APruebasustentacion
