"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"

$Global:Factory = "nycpayrollfactory"

az datafactory create `
    --location $RGLocation `
    --name $Factory `
    --resource-group $RGName