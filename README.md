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


3. Create a **SQL Database** to store the current year of the payroll data. For the two sub-steps bellow, run *commands\sql_db.ps1* to create resource automatically.

- In the Azure portal, create a SQL Database resource named *nycpayroll-db*

- Add client IP address to the SQL DB firewall

- Create a table called *NYC_Payroll_Data* in *db_nycpayroll* in the Azure Query Editor using the SQL Script *nyc_payroll_data.sql*

<img src="/pictures/create_nyc_payroll_data.png" title="create nyc_payroll_data table"  width="800">


4. Create A **Synapse Analytics workspace**. For all sub-steps bellow, run *commands\synapse.ps1*

- Create a new **Azure Data Lake Gen2** and file system for **Synapse Analytics** when you are creating the Synapse Analytics workspace in the Azure portal.

- Create a **SQL dedicated pool** in the **Synapse Analytics** workspace. Select DW100c as performance level. Keep defaults for other settings.

- In the **SQL dedicated pool**, Create master data tables and payroll transaction tables using the SQL scripts from *dedicated_pool_script.sql*.

<img src="/pictures/sql_dedicated_pool_tables.jpeg" title="sql dedicated pool tables"  width="600">



## Step 2: Create Linked Services


1. Create a **Linked Service** for **Azure Data Lake**

- In **Azure Data Factory**, create a linked service to the data lake that contains the data files

- From the data stores, select Azure Data Lake Gen 2

- Test the connection

<img src="/pictures/linked_service_data_lake.jpeg" title="linked service data lake"  width="600">


2. Create a **Linked Service** to SQL Database that has the current (2021) data. If you get a connection error, remember to add the IP address to the firewall settings in SQL DB in the Azure Portal.

<img src="/pictures/linked_service_sql_db.jpeg" title="linked service sql database"  width="600">


3. Create a **Linked Service** for **Synapse Analytics** : Create the linked service to the SQL pool.

<img src="/pictures/linked_service_sql_synapse" title="linked service synapse"  width="600">



## Step 3: Create Datasets in Azure Data Factory

1. Create the datasets for the 2021 Payroll file on Azure Data Lake Gen2

- Select DelimitedText
- Set the path to the nycpayroll_2021.csv in the Data Lake
- Preview the data to make sure it is correctly parsed

2. Repeat the same process to create datasets for the rest of the data files in the Data Lake

- EmpMaster.csv
- TitleMaster.csv
- AgencyMaster.csv
- Remember to publish all the datasets

3. Create the dataset for transaction data table that should contain current (2021) data in SQL DB

4. Create the datasets for destination (target) tables in Synapse Analytics

- dataset for NYC_Payroll_EMP_MD
- for *NYC_Payroll_TITLE_MD*
- for *NYC_Payroll_AGENCY_MD*
- for *NYC_Payroll_Data*



## Step 4: Create Data Flows

1. In **Azure Data Factory**, create the data flow to load 2021 Payroll Data to SQL DB transaction table (in the future NYC will load all the transaction data into this table).

- Create a new data flow
- Select the dataset for the 2021 payroll file as the source
- Select the sink dataset as the payroll table on SQL DB
- Make sure to reassign any missing source to target mappings

2. Create Pipeline to load 2021 Payroll data into transaction table in the SQL DB

- Create a new pipeline
- Select the data flow to load the 2021 file into SQLDB
- Trigger the pipeline
- Monitor the pipeline
- Take a screenshot of the Azure Data Factory screen pipeline run after it has finished.
- Make sure the data is successfully loaded into the SQL DB table

3. Create data flows to load the data from the data lake files into the Synapse Analytics data tables

- Create the data flows for loading Employee, Title, and Agency files into corresponding SQL pool tables on Synapse Analytics
- For each Employee, Title, and Agency file data flow, sink the data into each target Synaspe table

4. Create a data flow to load 2021 data from SQL DB to Synapse Analytics

5. Create pipelines for Employee, Title, Agency, and year 2021 Payroll transaction data to Synapse Analytics containing the data flows.

- Select the dirstaging folder in the data lake storage for staging
- Optionally you can also create one master pipeline to invoke all the Data Flows
Validate and publish the pipelines

6. Trigger and monitor the Pipelines

Take a screenshot of each pipeline run after it has finished, or one after your master pipeline run has finished.
In total, you should have 6 pipelines or one master pipeline



## Step 5: Data Aggregation and Parameterization

In this step, we'll extract the 2021 year data and historical data, merge, aggregate and store it in **Synapse Analytics**. The aggregation will be on Agency Name, Fiscal Year and TotalPaid.

1. Create a Summary table in Synapse with the SQL script from *summary_table.sql* and create a dataset named *table_synapse_nycpayroll_summary*

2. Create a new dataset for the **Azure Data Lake Gen2** folder that contains the historical files.

- Select *dirhistoryfiles* in the data lake as the source

3. Create new data flow and name it Dataflow Aggregate Data

- Create a data flow level parameter for Fiscal Year
- Add first Source for table_sqldb_nyc_payroll_data table
- Add second Source for the Azure Data Lake history folder

4. Create a new Union activity in the data flow and Union with history files

5. Add a Filter activity after Union

- In Expression Builder, enter toInteger(FiscalYear) >= $dataflow_param_fiscalyear

6. Derive a new TotalPaid column

- In Expression Builder, enter RegularGrossPaid + TotalOTPaid+TotalOtherPay

7. Add an Aggregate activity to the data flow next to the TotalPaid activity

- Under Group By, Select AgencyName and Fiscal Year

8. Add a Sink activity to the Data Flow

- Select the dataset to target (sink) the data into the Synapse Analytics Payroll Summary table.
In Settings, select Truncate Table

9. Create a new Pipeline and add the Aggregate data flow

- Create a new Global Parameter (This will be the Parameter at the global pipeline level that will be passed on to the data flow
- In Parameters, select Pipeline Expression
- Choose the parameter created at the Pipeline level

10. Validate, Publish and Trigger the pipeline. Enter the desired value for the parameter.

11. Monitor the Pipeline run and take a screenshot of the finished pipeline run.


## Step 6: Connect the Project to Github

In this step, we'll connect Azure Data Factory to Github

- Login to your Github account and create a new Repo in Github
- Connect Azure Data Factory to Github
- Select your Github repository in Azure Data Factory
- Publish all objects to the repository in Azure Data Factory
