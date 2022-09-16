

az synapse workspace create `
    --name nycpayrollsynapsews `
    --resource-group $RGName `
    --storage-account nycpayrollgen2 `
    --file-system nycpayrollfs `
    --sql-admin-login-user sqladminuser `
    --sql-admin-login-password Password123! `
    --location $RGLocation