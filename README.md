# Snowflake Features, Snowflake SQL 

Welcome to my Snowflake project! This repository aims to provide a comprehensive collection of Snowflake SQL scripts for managing various aspects of Snowflake, a popular cloud data platform. Whether you're new to Snowflake or looking to enhance your knowledge and skills, this project offers a range of scripts covering different features and functionalities.


## Table of Contents

- [Introduction](#introduction)
- [Snowflake Features](#snowflake-features)
- [Usage](#usage)
- [Contact](#contact)
- [References](#references)

## Introduction

The primary objective of this project is to facilitate learning and exploration of Snowflake's capabilities through practical examples and hands-on exercises. By examining these SQL scripts, users can gain insights into topics such as access control, performance optimization, data loading, and continuous data protection.

Whether you're a data engineer, analyst, or database administrator, you'll find valuable resources here to help you leverage Snowflake effectively in your projects. Feel free to explore the scripts, experiment with them in your Snowflake environment, and adapt them to suit your specific use cases.

I hope this repository is useful and informative. Happy querying!

## Snowflake Features

### 1. Snowflake Architecture

![image](https://github.com/srpayd/Snowflake-Project/assets/39004568/f7d6e8a4-68fe-47ac-8b5e-23a300721de4)

  
Snowflake’s architecture is a hybrid of traditional shared-disk and shared-nothing database architectures. Similar to shared-disk architectures, Snowflake uses a central data repository for persisted data that is accessible from all compute nodes in the platform. But similar to shared-nothing architectures, Snowflake processes queries using MPP (massively parallel processing) compute clusters where each node in the cluster stores a portion of the entire data set locally. This approach offers the data management simplicity of a shared-disk architecture, but with the performance and scale-out benefits of a shared-nothing architecture.

Snowflake’s unique architecture consists of three key layers:

- Database Storage

- Query Processing

- Cloud Services


### 2. Access Control and Security

- **Branch Name:** access-control-security-management
  
  **Description:** This branch contains SQL scripts for managing access control and security settings in a database environment. The scripts cover various aspects of access control, including role-based access control (RBAC), discretionary access control (DAC), and privilege management. Additionally, the scripts demonstrate the creation of masking policies and row access policies to protect sensitive data and enforce security restrictions. The branch serves as a reference for implementing robust security measures and managing access permissions within a database system.



### 3. Database-Objects 

- **Branch Name:** database-objects
  
  **Description:** This branch focuses on managing database objects in Snowflake through two hands-on exercises. These exercises offer practical insights into effectively managing database objects in Snowflake for database administrators and developers.

                    1. Databases, Schemas, Tables, and Views
                    
                    Demonstrates creating databases, schemas, and different types of tables.
                    Explains the creation of external tables and various types of views.
                    Includes examples of secure view functionality and access control.
                
                    2. User Defined Functions (UDFs), External Functions, and Stored Procedures
                    
                    Covers creating SQL and JavaScript UDFs, including overloading.
                    Introduces external functions for integration with external services.
                    Shows how to create a JavaScript stored procedure for database maintenance tasks.



### 4. Query Computing  

- **Branch Name:** virtual-warehouses
  
  **Description:** This branch contains SQL scripts for managing virtual warehouses in Snowflake. These scripts cover various aspects such as creating, configuring, and monitoring virtual warehouses, as well as exploring multi-cluster warehouse behavior and related configuration options. Additionally, the branch includes examples of tracking virtual warehouse usage, monitoring credit consumption, and setting up resource monitors to optimize credit utilization. Overall, this branch provides comprehensive guidance for effectively managing virtual warehouses in Snowflake to meet performance, scalability, and cost-efficiency requirements.

                    - Virtual Warehouses
                    - Multi-cluster Warehouse
                    - Query Optimization

### 4. Query Performance & Reclustering  

- **Branch Name:** query-performance
  
  **Description:** This branch introduces enhancements that optimize query performance in the Snowflake database environment. Divided into three distinct sections, the changes address various aspects of query execution, metadata caching, and clustering information systems. The updates include improvements in query history and performance metrics analysis, exploration of metadata and results caching techniques, and investigation of automatic clustering features alongside cost monitoring mechanisms. These enhancements aim to enhance query efficiency, reduce computational overhead, and provide insights into optimizing table storage and query execution.

                    - Query History and Performance Metrics:
                    - Metadata and Results Caching:
                    - Automatic Clustering and Cost Monitoring:

### 5. Data Loading and Unloading (Structured, Semi-structured, and Unstructured data)

- **Branch Name:** data-loading
  
  **Description:** This branch contains a comprehensive guide to data loading tasks in Snowflake, spanning multiple hands-on exercises. It covers various topics, including different **INSERT** statement variations and methods for uploading data via the UI. Additionally, it explores various **stage types**, both internal and external, and illustrates how to list, query, and remove staged data files. The repository also delves into **file formats**, **COPY options**, load transformations, and validation modes for efficient data loading. Moreover, it provides in-depth guidance on handling semi-structured data, particularly JSON files, utilizing methods such as ELT, ETL, and Automatic Schema Detection. Overall, this repository serves as a valuable resource for data engineers seeking to master data loading techniques within Snowflake environments.

                    - Structured Data Loading & Unloading & Transformation 
                    - Semi-structured Data Loading & Unloading & Transformation
                    - Unstructured Data Accessing, Sharing, Processing
  

### 6. Continuous Data Protection and Sharing 

- **Branch Name:** business-contiunity , data-sharing
  
  **Description:** (Time Travel, Fail-Safe, Replication, Data Cloning, Data Sharing, Data Exchange)

                    - Micro-partitions
                    - Time Travel, Fail-Safe 
                    - Data Replication, Cloning, Data Sharing, Data Exchange


## Usage

### Pre-requisites

To run the codes in this project, ensure the following prerequisites are met:
- A Snowflake account (here is a free trial Snowflake account or other Snowflake Edition information)
- Run the codes using the "Snowsight UI" or "SnowSQL" interface. (Please make sure you switched the right roles on your profile to acquire the desired results.

## Contact

Serap Aydogdu - [LinkedIn](https://www.linkedin.com/in/srpayd/) | [Medium](https://medium.com/@srpayd)

## Reference

This study benefits from the "Ultimate SnowPro Core Certification Course & Exam - 2024" online course on Udemy.
