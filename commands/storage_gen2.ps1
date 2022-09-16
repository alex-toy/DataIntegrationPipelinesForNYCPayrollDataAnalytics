$StorageAccount = "nycpayrollsaalexei"
$StorageContainer = "nycpayrollcontainer"

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
    --name dirpayrollfiles `
    --file-system $StorageContainer `
    --account-name $StorageAccount `
    --auth-mode key

az storage fs directory upload `
    --account-name $StorageAccount `
    --file-system $StorageContainer `
    --destination-path /dirpayrollfiles `
    --source "data/EmpMaster.csv" 

az storage fs directory upload `
    --account-name $StorageAccount `
    --file-system $StorageContainer `
    --destination-path /dirpayrollfiles `
    --source "data\AgencyMaster.csv" 

az storage fs directory upload `
    --account-name $StorageAccount `
    --file-system $StorageContainer `
    --destination-path /dirpayrollfiles `
    --source "data\TitleMaster.csv" 

az storage fs directory upload `
    --account-name $StorageAccount `
    --file-system $StorageContainer `
    --destination-path /dirpayrollfiles `
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




    
