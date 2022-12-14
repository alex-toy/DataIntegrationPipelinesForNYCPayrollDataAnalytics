"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"

$StorageAccount = "nycpayrollsaalexei"
$StorageContainer = "nycpayrollcontainer"
$DirectoryName = "dirpayrollfiles"

# CAUTION : in order to make the storage account a gen2, you need to set *hierarchical-namespace* as true.

az storage account create `
    --name $StorageAccount `
    --resource-group $RGName `
    --location $RGLocation `
    --sku Standard_LRS `
    --kind StorageV2 `
    --hierarchical-namespace true


az storage container create `
    --resource-group $RGName `
    --name $StorageContainer `
    --account-name $StorageAccount


az storage fs directory create `
    --name $DirectoryName `
    --file-system $StorageContainer `
    --account-name $StorageAccount `
    --auth-mode key

az storage fs directory upload `
    --account-name $StorageAccount `
    --file-system $StorageContainer `
    --destination-path /$DirectoryName `
    --source "data/EmpMaster.csv" 

az storage fs directory upload `
    --account-name $StorageAccount `
    --file-system $StorageContainer `
    --destination-path /$DirectoryName `
    --source "data\AgencyMaster.csv" 

az storage fs directory upload `
    --account-name $StorageAccount `
    --file-system $StorageContainer `
    --destination-path /$DirectoryName `
    --source "data\TitleMaster.csv" 

az storage fs directory upload `
    --account-name $StorageAccount `
    --file-system $StorageContainer `
    --destination-path /$DirectoryName `
    --source "data\nycpayroll_2021.csv"


az storage fs directory create `
    --name dirhistoryfiles `
    --file-system $StorageContainer `
    --account-name $StorageAccount `
    --auth-mode key

az storage fs directory upload `
    --account-name $StorageAccount `
    --file-system $StorageContainer `
    --destination-path /dirhistoryfiles `
    --source "data\nycpayroll_2020.csv"


az storage fs directory create `
    --name dirstaging `
    --file-system $StorageContainer `
    --account-name $StorageAccount `
    --auth-mode key




    
