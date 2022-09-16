az storage account create `
    --name nycpayrollsaalexei `
    --resource-group $RGName `
    --location $RGLocation `
    --sku Standard_LRS `
    --kind StorageV2 `
    --hierarchical-namespace true


az storage container create `
    --resource-group $RGName `
    --name nycpayrollcontainer `
    --account-name nycpayrollsaalexei


az storage fs directory create `
    --name dirpayrollfiles `
    --file-system nycpayrollcontainer `
    --account-name nycpayrollsaalexei `
    --auth-mode login

az storage fs directory upload `
    --account-name nycpayrollsaalexei `
    --file-system nycpayrollcontainer `
    --destination-path /dirpayrollfiles `
    --source "data/EmpMaster.csv" 

az storage fs directory upload `
    --account-name nycpayrollsaalexei `
    --file-system nycpayrollcontainer `
    --destination-path /dirpayrollfiles `
    --source "data\AgencyMaster.csv" 

az storage fs directory upload `
    --account-name nycpayrollsaalexei `
    --file-system nycpayrollcontainer `
    --destination-path /dirpayrollfiles `
    --source "data\TitleMaster.csv" 

az storage fs directory upload `
    --account-name nycpayrollsaalexei `
    --file-system nycpayrollcontainer `
    --destination-path /dirpayrollfiles `
    --source "data\nycpayroll_2021.csv"


az storage fs directory create `
    --name dirhistoryfiles `
    --file-system nycpayrollcontainer `
    --account-name nycpayrollsaalexei `
    --auth-mode login

az storage fs directory upload `
    --account-name nycpayrollsaalexei `
    --file-system nycpayrollcontainer `
    --destination-path /dirhistoryfiles `
    --source "data\nycpayroll_2020.csv"


az storage fs directory create `
    --name dirstaging `
    --file-system nycpayrollcontainer `
    --account-name nycpayrollsaalexei `
    --auth-mode login




    
