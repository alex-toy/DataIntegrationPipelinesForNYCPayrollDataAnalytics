"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"

$Global:RGLocation = "francecentral"
$Global:RGName = "nycpayrollrg"


az group create --name $RGName --location $RGLocation