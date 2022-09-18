"###############################################################"
"Now running : " + $MyInvocation.MyCommand.Path
"###############################################################"

az synapse data-flow create --file
                            --name
                            --workspace-name
                            [--no-wait]


az synapse data-flow create --workspace-name testsynapseworkspace \
  --name testdataflow --file @"path/dataflow.json"