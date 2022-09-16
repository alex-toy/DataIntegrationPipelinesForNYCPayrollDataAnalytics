#######################################################################
"datafactory :"

az datafactory create `
    --location $RGLocation `
    --name "nycpayroll" `
    --resource-group $RGName