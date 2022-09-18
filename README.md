# Data Integration Pipelines For NYC Payroll Data Analytics

## Context of the project

The City of New York would like to develop a Data Analytics platform on Azure Synapse Analytics to accomplish two primary objectives:

- Analyze how the City's financial resources are allocated and how much of the City's budget is being devoted to overtime.

- Make the data available to the interested public to show how the City’s budget is being spent on salary and overtime pay for all municipal employees.

The project needs Data Engineering skills to create high-quality data pipelines that are dynamic, can be automated, and monitored for efficient operation. The project team also includes the city’s quality assurance experts who will test the pipelines to find any errors and improve overall data quality.

The source data resides in **Azure Data Lake** and needs to be processed in a NYC data warehouse in **Azure Synapse Analytics**. The source datasets consist of CSV files with Employee master data and monthly payroll data entered by various City agencies.

<img src="/pictures/db-schema.jpeg" title="db schema"  width="400">


## Project resources

For this project, we'll work in the Azure Portal, using several Azure resources including:

- **Azure Data Lake Gen2**
- **Azure SQL DB**
- **Azure Data Factory**
- **Azure Synapse Analytics**

We will connect our **Azure pipelines** to this very Github repo and submit the URL or contents of the repository.


# Steps to reproduce the project

For all steps bellow, you can run the script files individually or run *commands\all_resources.ps1* to create all resources at once.

## Step 1 : Prepare the Data Infrastructure


1. Create the data lake and upload data. For all sub-steps bellow, run *commands\storage_gen2.ps1*

- Create an **Azure Data Lake Storage Gen2** (storage account) and associated storage container resource named *nycpayrollcontainer*. 

<img src="/pictures/nycpayrollcontainer.png" title="nycpayrollcontainer container"  width="600">

- Create the three following directories in this storage container :

    - *dirpayrollfiles*
    - *dirhistoryfiles*
    - *dirstaging*

<img src="/pictures/directories_to_container.png" title="directories uploaded to container"  width="600">

- Upload these files from the */data* folder to the *dirpayrollfiles* folder :

    - *EmpMaster.csv*
    - *AgencyMaster.csv*
    - *TitleMaster.csv*
    - *nycpayroll_2021.csv*

<img src="/pictures/files_to_dirpayrollfiles.png" title="files uploaded to dirpayrollfiles"  width="600">

- Upload the file *nycpayroll_2020.csv* from the project data to the *dirhistoryfiles* folder.

<img src="/pictures/files_to_dirhistoryfiles.png" title="files uploaded to dirhistoryfiles"  width="600">


2. Create an **Azure Data Factory** Resource. For this, run *commands\datafactory.ps1*

<img src="/pictures/factory.png" title="factory"  width="600">


3. Create a **SQL Database** to store the current year of the payroll data. For the two sub-steps bellow, run *commands\sql_db.ps1* to create resource automatically.

- In the Azure portal, create a SQL Database resource named *nycpayroll-db*

- Add client IP address to the SQL DB firewall

- Create a table called *NYC_Payroll_Data* in *db_nycpayroll* in the Azure Query Editor using the SQL Script *nyc_payroll_data.sql*

<img src="/pictures/create_nyc_payroll_data.png" title="create nyc_payroll_data table"  width="800">


4. Create A **Synapse Analytics workspace**. For all sub-steps bellow, run *commands\synapse.ps1*

<img src="/pictures/synapse.png" title="synapse"  width="600">

- Create a new **Azure Data Lake Gen2** and file system for **Synapse Analytics** when you are creating the Synapse Analytics workspace in the Azure portal.

- Create a **SQL dedicated pool** in the **Synapse Analytics** workspace. Select DW100c as performance level. Keep defaults for other settings.

<img src="/pictures/sql_dedicated_pool.png" title="sql dedicated pool"  width="600">

- Go into the **Networking** section of your **Synapse Workspace** and update the firewall rules :

<img src="/pictures/firewall_rules.png" title="firewall_rules"  width="600">

- In the **SQL dedicated pool**, Create master data tables and payroll transaction tables using the SQL scripts from *dedicated_pool_script.sql*. Dont forget to use the proper sql pool (*nycsqlpool*), not built-in :

<img src="/pictures/sql_dedicated_pool_tables.png" title="sql dedicated pool tables"  width="600">

You should see the tables properly created in your Data / Workspace :

<img src="/pictures/sql_dedicated_pool_tables2.png" title="sql dedicated pool tables"  width="300">



## Step 2: Create Linked Services


1. In **Azure Data Factory**, create a **Linked Service** for **Azure Data Lake**

- create a linked service to the data lake that contains the data files

- From the data stores, select **Azure Data Lake Gen 2**. Name : *DataLakeFiles*

<img src="/pictures/linked_service_data_lake.png" title="linked service data lake"  width="300">


2. In **Azure Data Factory**, create a **Linked Service** to SQL Database that has the current (2021) data. If you get a connection error, remember to add the IP address to the firewall settings in SQL DB in the Azure Portal. Name : *SqlDbCurrentData*

<img src="/pictures/linked_service_sql_db.png" title="linked service sql database"  width="300">


3. In **Azure Data Factory**, create a **Linked Service** : Create the linked service to the SQL pool. Name :  *SynapseSqlPool*

<img src="/pictures/linked_service_sql_synapse.png" title="linked service synapse"  width="300">

In the end, you should have this :

<img src="/pictures/linked_service1.png" title="linked service final"  width="500">
<img src="/pictures/linked_service2.png" title="linked service final"  width="500">





## Step 3: Create Datasets in Azure Data Factory

1. Create the datasets for the 2021 Payroll file on **Azure Data Lake Gen2**. Call it *dataset_2021_payroll*

- Select DelimitedText
- Set the path to the *nycpayroll_2021.csv* in the Data Lake

<img src="/pictures/dataset_2021_payroll.png" title="datasets for the 2021 Payroll file"  width="600">

- Preview the data to make sure it is correctly parsed

<img src="/pictures/dataset_2021_payroll_preview.png" title="datasets for the 2021 Payroll file preview"  width="600">


2. Repeat the same process to create datasets for the rest of the data files in the Data Lake

- *EmpMaster.csv*. Name : *dataset_EmpMaster*

<img src="/pictures/dataset_EmpMaster.png" title="datasets EmpMaster"  width="600">

- *TitleMaster.csv*. Name : *dataset_TitleMaster*

<img src="/pictures/dataset_TitleMaster.png" title="datasets TitleMaster"  width="600">

- *AgencyMaster.csv*. Name : *dataset_AgencyMaster*

<img src="/pictures/dataset_AgencyMaster.png" title="datasets AgencyMaster"  width="600">

- Publish all the datasets

3. Create the dataset for transaction data table that should contain current (2021) data in SQL DB. Name : *dataset_nycpayroll_db*

<img src="/pictures/dataset_current_2021_data.png" title="datasets current 2021 data"  width="600">

4. Create the datasets for destination (target) tables in **Synapse Analytics**

- dataset for *NYC_Payroll_EMP_MD*. Name : *dataset_NYC_Payroll_EMP_MD*

<img src="/pictures/dataset_NYC_Payroll_EMP_MD.png" title="datasets NYC_Payroll_EMP_MD"  width="600">

- for *NYC_Payroll_TITLE_MD*. Name : *dataset_NYC_Payroll_TITLE_MD*

<img src="/pictures/dataset_NYC_Payroll_TITLE_MD.png" title="datasets NYC_Payroll_TITLE_MD"  width="600">

- for *NYC_Payroll_AGENCY_MD*. Name : *dataset_NYC_Payroll_AGENCY_MD*

<img src="/pictures/dataset_NYC_Payroll_AGENCY_MD.png" title="datasets NYC_Payroll_AGENCY_MD"  width="600">

- for *NYC_Payroll_Data*. Name : *dataset_NYC_Payroll_Data*

<img src="/pictures/dataset_NYC_Payroll_Data.png" title="datasets NYC_Payroll_Data"  width="600">

- Publish all the datasets


## Step 4: Create Data Flows

1. In **Azure Data Factory**, create the data flow to load *2021 Payroll* Data to SQL DB transaction table (in the future NYC will load all the transaction data into this table).

- Create a new data flow
- Select the dataset for the 2021 payroll file as the source

<img src="/pictures/dataflow_2021_payroll_data.png" title="dataflow 2021 payroll data"  width="600">
<img src="/pictures/dataflow_2021_payroll_data_preview.png" title="dataflow 2021 payroll data preview"  width="600">

- Select the sink dataset as the *payroll* table on SQL DB

<img src="/pictures/dataflow_payroll_table_sql_db.png" title="dataflow payroll table on SQL DB"  width="600">
<img src="/pictures/dataflow_payroll_table_sql_db_preview.png" title="dataflow payroll table on SQL DB preview"  width="600">

- Make sure to reassign any missing source to target mappings

2. Create Pipeline to load *2021 Payroll* data into transaction table in the SQL DB

- Create a new pipeline
- Select the data flow to load the 2021 file into SQLDB

<img src="/pictures/pipeline_load_2021_into_sql.png" title="pipeline load the 2021 file into SQLDB"  width="600">

- Trigger the pipeline

<img src="/pictures/pipeline_trigger.png" title="pipeline trigger"  width="600">

- Monitor the pipeline

<img src="/pictures/pipeline_finished.png" title="pipeline finished"  width="600">

- Make sure the data is successfully loaded into the SQL DB table

<img src="/pictures/successfully_loaded_into_sql.png" title="successfully loaded into SQL"  width="600">


3. Create data flows to load the data from the data lake files into the Synapse Analytics data tables

- Create the data flows for loading *Employee*, *Title*, and *Agency* files into corresponding SQL pool tables on **Synapse Analytics**

- For each *Employee*, *Title*, and *Agency* file data flow, sink the data into each target Synaspe table

<img src="/pictures/dataflow_employee.png" title="dataflow employee"  width="600">
<img src="/pictures/dataflow_title.png" title="dataflow title"  width="600">
<img src="/pictures/dataflow_agency.png" title="dataflow agency"  width="600">

4. Create a data flow to load 2021 data from SQL DB to Synapse Analytics

<img src="/pictures/dataflow_2021_from_sql_to_synapse.png" title="dataflow load 2021 data from SQL DB to Synapse Analytics"  width="600">
<img src="/pictures/dataflow_2021_from_sql_to_synapse2.png" title="dataflow load 2021 data from SQL DB to Synapse Analytics"  width="600">

5. Create pipelines for *Employee*, *Title*, *Agency*, and *year 2021 Payroll transaction* data to **Synapse Analytics** containing the data flows. Optionally you can also create one master pipeline to invoke all the Data Flows.

- Select the dirstaging folder in the data lake storage for staging

<img src="/pictures/pipeline_employee_Title_Agency1.png" title="pipeline for Employee, Title, Agency"  width="600">
<img src="/pictures/pipeline_employee_Title_Agency2.png" title="pipeline for Employee, Title, Agency"  width="600">

- Validate and publish the pipelines

<img src="/pictures/pipeline_employee_Title_Agency3.png" title="pipeline for Employee, Title, Agency"  width="600">

6. Trigger and monitor the Pipelines

<img src="/pictures/pipeline_employee_Title_Agency_run.png" title="pipeline for Employee, Title, Agency run"  width="600">


7. View the results

<img src="/pictures/synapse_agency.png" title="Agency on synapse"  width="600">
<img src="/pictures/synapse_payroll.png" title="payroll on synapse"  width="600">
<img src="/pictures/synapse_emp.png" title="employee on synapse"  width="600">
<img src="/pictures/synapse_title.png" title="title on synapse"  width="600">
<img src="/pictures/storage_staging.png" title="storage staging"  width="600">



## Step 5: Data Aggregation and Parameterization

In this step, we'll extract the 2021 year data and historical data, merge, aggregate and store it in **Synapse Analytics**. The aggregation will be on Agency Name, Fiscal Year and TotalPaid.

1. Create a Summary table in Synapse with the SQL script from *summary_table.sql* and create a dataset named *table_synapse_nycpayroll_summary*

2. Create a new dataset for the **Azure Data Lake Gen2** folder that contains the historical files.

- Select *dirhistoryfiles* in the data lake as the source

3. Create new data flow and name it Dataflow Aggregate Data

- Create a data flow level parameter for Fiscal Year
- Add first Source for *table_sqldb_nyc_payroll_data* table
- Add second Source for the Azure Data Lake history folder

4. Create a new Union activity in the data flow and Union with history files

5. Add a Filter activity after Union

- In Expression Builder, enter 
```
toInteger(FiscalYear) >= $dataflow_param_fiscalyear
```

6. Derive a new *TotalPaid* column

- In Expression Builder, enter 
```
RegularGrossPaid + TotalOTPaid+TotalOtherPay
```

7. Add an Aggregate activity to the data flow next to the *TotalPaid* activity

- Under Group By, Select AgencyName and Fiscal Year

8. Add a Sink activity to the Data Flow

- Select the dataset to target (sink) the data into the Synapse Analytics Payroll Summary table.
In Settings, select Truncate Table

9. Create a new Pipeline and add the Aggregate data flow

- Create a new Global Parameter (This will be the Parameter at the global pipeline level that will be passed on to the data flow)
- In Parameters, select **Pipeline Expression**
- Choose the parameter created at the Pipeline level

10. Validate, Publish and Trigger the pipeline. Enter the desired value for the parameter.

11. Monitor the Pipeline run and take a screenshot of the finished pipeline run.


## Step 6: Connect the Project to Github

In this step, we'll connect Azure Data Factory to Github

- Login to your Github account and create a new Repo in Github
- Connect Azure Data Factory to Github
- Select your Github repository in Azure Data Factory
- Publish all objects to the repository in Azure Data Factory
