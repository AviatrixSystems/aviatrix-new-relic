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

Start by setting up a target VPC and Subnet on AWS.  The subnet must automatically assign public IPs to each VM (this simplifies the terraform config but is clearly not good practice).  In the [variables.tf](./terraform/variables.tf) set the vpc_id, subnet_id, and prefix.

In the command line log set up AWS Access, either by 
- exporting the environment variables AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY,AWS_SESSION_TOKEN
- setting up an AWS profile, and if not default exporting the AWS_PROFILE variable
- Logging in with `aws sso login`

You should now be able to successfully run `terraform init` followed by `terraform plan`.

Deploy the hoodie app with command `terraform apply` selecting yes if the plan seems sensible (it should create VMs, DBs, and security groups.  It should not create VPCs or subnets).

Assuming deployment is successful, keep a note of the enpoints that are output.

Browse to the `frontend_main_uri` output url and you should see the application frontend.  Click `Catalog` and you should be able to browse and "purchase" hoodies.  Purchasing a "Glitchy" hoodie should fail.

### Configuring Flex

You should have already configure the flex agent as described [here](../README.md).  Add a copy of the hoodie.yml per hoodie deployment to `/etc/newrelic-infra/integrations/` - how you name this file is not important as long as it has the extension `.yml`. Update the values `<backend_main_uri>` and `<AWS Account>`.  You can test, as before, with:

    sudo /opt/newrelic-infra/newrelic-integrations/bin/nri-flex  --verbose --pretty --config_file /etc/newrelic-infra/integrations/hoodie.yml

Output should be COUNT, MAX, and TOTAL_TIME for each of HoodieTotalCountSample, HoodieFailedCountSample, and HoodieOrderCountSample.

### Adding Dashboards

If you have already setup an Aviatrix Dashboard following the instructions [here](../README.md) then you can configure the remaining dashboards using the json files in the [./NR-dashboard-code](./NR-dashboard-code) folder using the same process.  You will need to edit the *Overview* dashboard so that the queries for each row use the correct Account name.  You can either edit the json before importing e.g. by replacing all instances of `hoodie-london-account` with the account name for the first row, or you can edit each widget using the New Relic interface after import.  If you decide to use the New Relic interface make sure you edit each query for each widget as the line graphs use multiple queries.

You can only configure the links on the left-hand side of the overview page after all the dashboards have been set up.  For each link you need to go to the target dashboard, select the target account, and then click the link icon on the top left to copy the url.  Then put this url as the link target on the overview page.

### Generating traffic

In the folder [./Traffic-Scripts](./Traffic-Scripts) are scripts for generating traffic to the hoodie application.  These have not been well parameterized. The files [purchase-hoodie.sh](./Traffic-Scripts/purchase-hoodie.sh) and [purchase-hoodie-fail.sh](./Traffic-Scripts/purchase-hoodie-fail.sh) will generate a single purchase and a single failed purchase respectively.  Update the targeturl to be the `backend_main_uri` from your terraform output to make these work.

The files [random-purchase.sh](./Traffic-Scripts/random-purchase.sh) and [random-purchase-fail.sh](./Traffic-Scripts/random-purchase-fail.sh) call the purchase scripts a random number of times (you can change the range in these scripts but default is 1..10 purchases and 1..2 fails).  I generally run the scripts using the `watch` command, but you may need to install this if you are using a mac.

    watch ./random-purchase.sh

for normal traffic.

Make a copy of these files for each deployment of the hoodie app that you have.

### Setting up for a network failure

To simulate a network failure during the demo we want to disable an Aviatrix managed gateway by deleting security group rules.  As the hoodie application is using EIPs you will first need to configure a *Public Subnet Filtering Gateway* in Aviatrix.  Do this for the VPC/subnet for the instance of the hoodie application that you wish to break.  You should then be able to see traffic to the hoodie application going through this gateway in the *Copilot*.

## Running the demo

Navigate to the overview dashboard.  Each application should be "green" and the traffic should look sensible.  You may wish to navigate to each of the other dashboards to show the healthy version of the application.

### Demoing an application bug

Start the [random-purchase-fail.sh](./Traffic-Scripts/random-purchase-fail.sh) script running e.g.

    watch ./random-purchase-fail.sh

After a few seconds the "Traffic Light" will turn amber.  Roughly 30 seconds after this you will start to see errors being displayed on the traffic graph.  At this point you could click into the "Shared Full" dashboard to show that the network looks healthy and the only indication of a problem is the failures (http 500 errors) coming from the hoodie server.  Discuss how this would suggest a problem with the application, and how this is hopefully clear to each team, devs, ops, etc.

Kill the watch command if you want the application to return to healthy.  Point out that this takes longer as it takes a longer period of stabilisation for the dashboard to be confident that the error has gone.

### Demoing a network error

In the AWS console select the region that your hoodie application is running in.  Go to the VPC section of the console and go to security groups.  There will be a security group with a name that matches the name of the *Public Subnet Filtering Gateway* that you created.  Delete all the incoming and outbound rules for this security group.  You will be able to see traffic stop almost immediately in the New Relic console.  Soon the "Traffic Light" will appear red.  It may appear half green and half red until both the public and spoke gateways start to show as unhealthy.

You could now go to the *Shared Full* dashboard and show that the gateways are unhealthy and and that traffic through the public gateway has dropped to nothing.  Discuss how this would implicate the network and navigate to the *Aviatrix* dashboard to show possible further details.  In this case we won't show anything extra as the gateway itself is actually healthy and within capacity, just not reachable.

You could now go to the Aviatrix Copilot console to show how you could further dig into the problem.

To restore the security group add all traffic to all ports rules to both inbound and outbound traffic on the security group.