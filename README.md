# Building an Azure Data Warehouse for Bike Share Data Analytics 

Divvy is a bike sharing program in Chicago, Illinois USA that allows riders to purchase a pass at a kiosk or use a mobile application to unlock a bike at stations around the city and use the bike for a specified amount of time. The bikes can be returned to the same station or to another station. The City of Chicago makes the anonymized bike trip data publicly available for projects like this where we can analyze the data.

Since the data from Divvy are anonymous, we have created fake rider and account profiles along with fake payment data to go along with the data from Divvy. The dataset looks like this:

<img src="screenshots/divvy-erd.png" title="divvy-erd">

## The goal of this project

### To develop a data warehouse solution using Azure Synapse Analytics

You will:
* Design a star schema based on the business outcomes listed below;
* Import the data into Synapse;
* Transform the data into the star schema;
* and finally, view the reports from Analytics.

## The business outcomes you are designing for are as follows:

1. Analyze how much time is spent per ride
* Based on date and time factors such as day of week and time of day
* Based on which station is the starting and / or ending station
* Based on age of the rider at time of the ride
* Based on whether the rider is a member or a casual rider

2. Analyze how much money is spent
* Per month, quarter, year
* Per member, based on the age of the rider at account start

3. EXTRA CREDIT - Analyze how much money is spent per member
* Based on how many rides the rider averages per month
* Based on how many minutes the rider spends on a bike per month

## Getting started

What do you need in this project mostly is an Azure account.

## Task 1: Create your Azure resources

* Create an Azure Database for PostgreSQL.
* Create an Azure Synapse workspace. Note that if you've previously created a Synapse Workspace, you do not need to create a second one specifically for the project.
* Use the built-in serverless SQL pool and database within the Synapse workspace

## Task 2: Design a star schema

Below you can find the designed star schema:

<img src="screenshots/PostgreSQL.jpg" title="star-schema">

## Task 3: Create the data in PostgreSQL

To prepare your environment for this project, you first must create the data in PostgreSQL. This will simulate the production environment where the data is being used in the OLTP system. This can be done using the Python script provided for you in ProjectDataToPostgres.py

You can verify this data exists by using pgAdmin or a similar PostgreSQL data tool.

## Task 4: EXTRACT the data from PostgreSQL

## Task 5: LOAD the data into external tables in the data warehouse

## Task 6: TRANSFORM the data to the star schema using CETAS