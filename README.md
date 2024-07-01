Welcome to your new dbt project!

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

### 1. Clone the Repository

```sh
git clone https://github.com/venkateshmaisur/hevodata.git
cd hevodata

2. Create and Activate a Virtual Environment

python -m venv dbt-env
source dbt-env/bin/activate

3. Install dbt

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

dbt run

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
