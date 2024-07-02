### Welcome to Hevodata Technical Assessment ###

# Data Pipeline Project

This project outlines the steps to set up a data pipeline involving PostgreSQL, Hevo, Snowflake and DBT to create a materialized table in Snowflake

## Prerequisites

- Install Docker
- Pull Postgres latest image
- Setup Hevo account
- Setup Snowflake account and necessary credentials
- Git
- Python
- DBT

## Install Docker

Follow the link below to install and setup docker service

https://docs.docker.com/engine/install/centos/

## PostgreSQL Setup

### 1. Install PostgreSQL

docker pull postgres

### 2. Create a Database and User

docker run --name postgresql -e POSTGRES_USER=<username> -e POSTGRES_PASSWORD=<password> -p 5432:5432 -d postgres

docker ps -a  ## To check docker container postgresql is up or not

docker start|stop|restart postgresql

### 3. Configure PostgreSQL for Remote Access and Set up Log-based Incremental Replication

docker exec -it postgresql /bin/bash

vim /var/lib/postgresql/data/postgresql.conf
listen_addresses = '*'
wal_level = logical
max_replication_slots = 4
max_wal_senders = 4

vim /var/lib/postgresql/data/pg_hba.conf
host    all             all             0.0.0.0/0               md5
local   replication     <user>                                  peer
host    replication     <user>          127.0.0.1/0             md5
host    replication     <user>          ::1/0                   md5

exit

docker restart postgresql

docker exec -it postgresql /bin/bash

psql -U <username -d <db_name>

alter role <user> with replication;

show wal_level;

show max_replication_slots;

show max_wal_senders;

### 4. As part of assignment create below tables and load data that shared through csv files

CREATE TABLE raw_customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE raw_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20) -- Add this line if your CSV has a status column
);

CREATE TABLE raw_payments (
    payment_id INT PRIMARY KEY,
    customer_id INT,
    payment_type VARCHAR(50),
    amount DECIMAL(10, 2)
);

exit
exit

docker cp /path/to/raw_customers.csv postgres:/tmp/raw_customers.csv
docker cp /path/to/raw_orders.csv postgres:/tmp/raw_orders.csv
docker cp /path/to/raw_payments.csv postgres:/tmp/raw_payments.csv
docker exec -it postgres psql -U postgres

COPY raw_customers FROM '/tmp/raw_customers.csv' DELIMITER ',' CSV HEADER;
COPY raw_orders FROM '/tmp/raw_orders.csv' DELIMITER ',' CSV HEADER;
COPY raw_payments FROM '/tmp/raw_payments.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM raw_customers;
SELECT * FROM raw_orders;
SELECT * FROM raw_payments;

## Snowflake Setup

### 5. Setup Snowflake trail account and create Warehouse, DB and Schema

Log in to your Snowflake account at [Snowflake.](https://app.snowflake.com/)

CREATE OR REPLACE WAREHOUSE HEVO_WAREHOUSE
WITH
WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 300
AUTO_RESUME = TRUE
INITIALLY_SUSPENDED = TRUE;

CREATE OR REPLACE DATABASE HEVO_DB;

CREATE OR REPLACE SCHEMA HEVO_SCHEMA;

Now create a login user and grant respective privileges to use for DBT 

### 6. Create a Pipeline in Hevodata for Source/Destination by following below doc

https://docs.hevodata.com/pipelines/

Add a Source:

Configure PostgreSQL as Source:

Database Host: Your Docker container IP
Port: 5432
Username: <username>
Password: <password>
Database Name: <database>
Replication Slot: <name>
Click "Test Connection" to ensure it works.

Add a Destination:

Select "Snowflake" as the destination.
Provide the necessary Snowflake connection details:
Account URL
Warehouse
Database
Schema
Username
Password
Click "Test Connection" to ensure it works.

Create the Pipeline:

Review your settings and click "Create Pipeline".
Start the Pipeline:

After creating the pipeline, start it to begin data replication from your PostgreSQL instance to Snowflake.
Verify the Replication
Ensure that data is being replicated from your PostgreSQL database to Snowflake as expected.
Monitor the pipeline in Hevo for any errors or issues.

### To address below screen shot query ###

Question: Once the data has been loaded into the Snowflake warehouse model, the data using
          “dbt” to build materialized table “customers” with the following columns

<img width="581" alt="image" src="https://github.com/venkateshmaisur/hevodata/assets/33508734/9efde366-95b7-4c47-9394-0cbc6329b9fd">

### Now complete your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test

# DBT Project

This repository contains a dbt project for transforming data in Snowflake. Below are the steps to set up, run, and push the project to the GitHub repository.

## Prerequisites

- Python 3.9 or later
- `virtualenv` package
- dbt (data build tool)
- Snowflake account and necessary credentials
- Git

## Setup

1. Clone the Repository

git clone https://github.com/venkateshmaisur/hevodata.git

cd hevodata

2. Create and Activate a Virtual Environment

python -m venv dbt-env
source dbt-env/bin/activate

3. Install dbt and 

pip install dbt

4. Set Up dbt Profile
Create the profiles directory if it doesn't exist:

mkdir -p ~/.dbt

Create a profiles.yml file in the ~/.dbt directory with the following content:

my_dbt_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: qghmomc-pc13062
      user: test_user
      password: your_password_here
      role: transform
      database: HEVO_DB
      warehouse: HEVO_WAREHOUSE
      schema: HEVO_SCHEMA
      threads: 1
      client_session_keep_alive: False
      query_tag: anything

Replace your_password_here with your actual Snowflake password.

Running dbt Commands

1. Debug the Connection

dbt debug --log-level debug

2. Run dbt Models

Created a materialized table "customers" available at models/example/customer.sql

dbt run

Output of the screenshot from Snowflake is available at "snapshots"

Pushing to GitHub

1. Configure Git

git config --global user.name "Your Name"

git config --global user.email "your.email@example.com"

2. Add and Commit Changes

git add .
git commit -m "Initial commit of dbt project"

3. Push Changes to main Branch

git push -u origin main

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
