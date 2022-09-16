az datafactory linked-service create --factory-name
                                     --linked-service-name
                                     --properties
                                     --resource-group
                                     [--if-match]


az datafactory linked-service create 
    --factory-name "exampleFactoryName" 
    --properties "{\"type\":\"AzureStorage\",\"typeProperties\":{\"connectionString\":{\"type\":\"SecureString\",\"value\":\"DefaultEndpointsProtocol=https;AccountName=examplestorageaccount;AccountKey=<storage key>\"}}}" 
    --name "exampleLinkedService" 
    --resource-group "exampleResourceGroup"