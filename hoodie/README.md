# Running a Aviatrix to New Relic demo with Hoodie App

The hoodie app is a demo application that we can quickly deploy and use.  It returns some useful health and metrics data and by "purchasing" the "glitchy" hoodie we can generate error data.

There files for configuring this with new relic and scripts for generating traffic.

This document walks through the setup and steps for demoing:
    
    - Dashboards that combine data from Aviatrix and an Application running on an Aviatrix managed network
    - An application based unstable state where we can see from the Dashboard that this failure is not caused by the network
    - An error with a network configuration that we can see based on the status and metrics data coming from Aviatrix

## Setup and Configuration

### Terraform
    
The [terraform](./terraform) folder contains the terraform files required to deploy and instance of the hoodie commerce application.

**NB.** It is probably sensible to make a copy of this folder for each deployment of the hoodie application that you intend to do as it doesn't currently support multiple deployments.

Start by setting up a target VPC and Subnet on AWS.  The subnet must automatically assign public IPs to each VM (this simplifies the terraform config but is clearly not good practice).  In the `variables.tf` 