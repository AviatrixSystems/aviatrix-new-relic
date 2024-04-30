# aviatrix-new-relic

This repo contains scripts and instructions for setting up an integration between Aviatrix CoPilot and New Relic.

## Integration details

The Aviatrix to New Relic integration uses [Flex](https://docs.newrelic.com/docs/infrastructure/host-integrations/host-integrations-list/flex-integration-tool-build-your-own-integration/) to pull metrics from the CoPilot API. Flex uses the [New Relic Infrastructure Agent](https://docs.newrelic.com/docs/infrastructure/install-infrastructure-agent/get-started/install-infrastructure-agent/) to push the data to NR. [jq](https://jqlang.github.io/jq/) is also required for the agent to parse the incoming json.

This repository uses docker to bundle these 3 components to produce the suitable runtime environment.

The integration will populate the following tables in New Relic:

* `AviatrixBgpStatusSample` Bgp routing status
* `AviatrixGatewayStatusSample` Aviatrix Gateway status
* `AviatrixTunnelStatusSample` Aviatrix Tunnel status
* `AviatrixGWMetricsUriSample` Aviatrix Gateway VM Metrics
* `AviatrixMetricsUriSample` Aviatrix Interface Metrics

## Getting started

### Prerequisites

#### Docker

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

#### Aviatrix Network Insights API key

Create an Aviatrix Network Insights api key by following the instructions for [Monitoring with Network Insights API](https://docs.aviatrix.com/documentation/latest/monitoring-troubleshooting/metrics-api-enable.html?expand=true)

#### New Relic license key

Create a New Relic license api key by following the instructions for [New Relic API keys](https://docs.newrelic.com/docs/apis/intro-apis/new-relic-api-keys/)

#### New Relic lookup tables

A lookup table with your account information needs to be set up to associate data coming from the Aviatrix API. This is a manual step that needs to be updated when your network topology changes.

In Aviatrix CoPilot, navigate to `Cloud Fabric` -> `Gateways` -> `Gateway Management`. Download a csv file of this table using the download button next to `Actions`.

In New Relic Navigate to `Logs` -> `Lookup Tables`.  If this is the first time you have done this click `Add Table`.  Name the table `Accounts` and select the csv file you just downloaded. When you want to update this table click `...` next to the table and select `replace`.

### Usage

#### Environment variables

The out-of-the-box execution examples below rely on environment variables created on the host being passed via the docker command(s) to the container. This is intended for ease of setup and testing. Be mindful of setting environment variables via the command line to avoid exposing secrets in shell history. Refer to the [Securing bearer tokens and urls](#securing-bearer-tokens-and-urls) section below for additional details.

For production environments, expose the environment variables to the container in the method that complies with your security requirements and container hosting platform.

The following environment variables are required:

* `CPLT_DOMAIN` - The domain name or IP of your Aviatrix CoPilot instance.
* `CPLT_API_KEY` - The Aviatrix Network Insights API key.
* `NRIA_LICENSE_KEY` - The New Relic license api key.

#### Relevant directory and file locations

* `/config/newrelic-infra.yml` - Configuration for New Relic infrastructure agent and Flex
* `/scripts/` - Flex scripts for collecting Aviatrix Network Insights and formatting them for New Relic
* `/sample-dashboards` - Sample dashboard json that can be modified and used as a starting point for building your own dashboards

#### Built with

* New Relic infrastructure agent v1.52.0

#### Example execution

##### Build

```bash
docker build --tag 'avx_new_relic' .
```

##### Run (interactive)

```bash
docker run \
    -e CPLT_API_KEY=$CPLT_API_KEY \
    -e CPLT_DOMAIN=$CPLT_DOMAIN \
    -e NRIA_LICENSE_KEY=$NRIA_LICENSE_KEY \
    avx_new_relic
```

##### Run (detached)

```bash
docker run -d \
    -e CPLT_API_KEY=$CPLT_API_KEY \
    -e CPLT_DOMAIN=$CPLT_DOMAIN \
    -e NRIA_LICENSE_KEY=$NRIA_LICENSE_KEY \
    avx_new_relic
```

## Securing bearer tokens and urls

There are a number of different ways to secure keys and other shared data within your New Relic environment.  It is important that you do this but there are different steps to follow depending on the approach that you are going to follow.  The latest approaches are documented [here](https://docs.newrelic.com/docs/infrastructure/host-integrations/installation/secrets-management/) and are quick and easy to follow.  

You may however, be using the deprecated approach detailed [here](https://github.com/newrelic/nri-flex/blob/master/docs/deprecated/secrets.md) within your current New Relic setup.  In this case you can use the documented steps but this is a bit more effort and New Relic recommend that you move the new way.

## Importing the example dashboard

The json file in [./sample-dashboard/dashboard.json](./sample-dashboard/dashboard.json) contains an example dashboard.  Modify the contents of this file, updating your `accountIds` and gateway names as applicable. Then, copy the contents to your clipboard and, in New Relic, go to `Dashboards` and click `Import Dashboard`.  Paste the json and click `Import Dashboard` again.
You should now see the dashboard `Aviatrix Status Dashboard`.

## Troubleshooting the integration

Running your container interactively with the `NRIA_LOG_LEVEL` set to debug is a great way to troubleshoot the flex scripts for issues with pulling metrics from the Aviatrix Network Insights API or posting the results to New Relic.

### Run (interactive, verbose)

```bash
docker run \
    -e CPLT_API_KEY=$CPLT_API_KEY \
    -e CPLT_DOMAIN=$CPLT_DOMAIN \
    -e NRIA_LICENSE_KEY=$NRIA_LICENSE_KEY \
    -e NRIA_LOG_LEVEL=debug \
    avx_new_relic
```
