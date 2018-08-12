# Introduction

All the requirements to the *assessment-1* are attached [here](../README.md).

In this page the interviewee shares and presents all the details about:

- What are the deliverables;

- How to use the deliverable;

- How the interviewee solved the assessment;

- What are the assumptions and etc.

## Hardware and software requirements

### Hardware requirements

There are not hardware requirements. A recent laptop, PC or a virtual machine
with Linux operating system will be fine.

*Note:* all the assessment was solved on a Linux machine. The next section
presents the software requirements.

### Software requirements

Given a Linux operating system, it is required to install the following Software:

- Git: at least version 2.17.1;

- Powershell: at least version 6.1.0;

- Make: at least version 4.1;

- AZ CLI: at least version 2.0.43;

To find out, how to install the tools have a look at the *Installation Guide*
specific for the operating system in use.

### Logical requirements

In order to execute the scripts on Azure Cloud, there are required the following:

- A valid account with sufficient permissions to manage different Azure's resources;

- A valid ServicePrincipal account.

In case all the software is already installed on a proper machine; the accounts
are created and have sufficient permissions, go to [next page](./files/00-first-checks.md).

*Note:*
The choice for the Text Editor is free. But it is recommended to use Studio Code
text editor with the following installed extensions:

- PowerShell v1.8.3;

- Azure Resource Manager Tools v0.4.2;

- Terminal Tabs v0.2.0.