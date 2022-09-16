#######################################################################
"datafactory :"

$Global:Factory = "nycpayrollfactory"

az datafactory create `
    --location $RGLocation `
    --name $Factory `
    --resource-group $RGName