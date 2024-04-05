# new-relic-scripts

This repo contains scripts and instructions for setting up an integration between Aviatrix copilot and New Relic.

## Setting up the New Relic Flex Agent

The Aviatrix to New Relic integration uses [Flex](https://docs.newrelic.com/docs/infrastructure/host-integrations/host-integrations-list/flex-integration-tool-build-your-own-integration/) to pull metrics from the Copilot API.  Flex use the [infrastructure agent](https://docs.newrelic.com/docs/infrastructure/install-infrastructure-agent/get-started/install-infrastructure-agent/) so this needs to be installed on a suitable VM.  This VM also needs [jq](https://jqlang.github.io/jq/) installed for the agent to parse the incoming json but this seems to be standard on most linux distributions.

Once the infrastructure agent has been installed update the configuration files in [NR-Agent-Config](./NR-Agent-Config) with url and token to access you copilot instance.  These files then need to be placed in the integrations folder of your agent config.  On linux this seems to be `/etc/newrelic-infra/integrations.d/`.

At this point you can test the configuration is working by running (for example)
    
    sudo /opt/newrelic-infra/newrelic-integrations/bin/nri-flex  --verbose --pretty --config_file /etc/newrelic-infra/integrations/uri-status.yml

You should get a response with something like:

```json
{
	"name": "com.newrelic.nri-flex",
	"protocol_version": "3",
	"integration_version": "1.10.0",
	"data": [
		{
			"metrics": [
				{
					"baseUrl": "https://cplt.pod150.aviatrixlab.com/",
					"event_type": "AviatrixGatewayStatusSample",
					"id": "Hoodie-Oregon",
					"integration_name": "com.newrelic.nri-flex",
					"integration_version": "1.10.0",
					"lastUpdatedTimestamp": "2024-03-25T11:36:13.258Z",
					"status": "up"
				},
...
              {
                "event_type": "flexStatusSample",
                "flex.Hostname": "ip-172-31-25-112.eu-west-1.compute.internal",
                "flex.IntegrationVersion": "1.10.0",
                "flex.counter.AviatrixBgpStatusSample": 1,
                "flex.counter.AviatrixGatewayStatusSample": 8,
                "flex.counter.AviatrixTunnelStatusSample": 8,
                "flex.counter.ConfigsProcessed": 1,
                "flex.counter.EventCount": 17,
                "flex.counter.EventDropCount": 0,
                "flex.counter.HttpRequests": 3,
                "flex.time.elapsedMs": 318,
                "flex.time.endMs": 1712301568215,
                "flex.time.startMs": 1712301567897
              }
            ],
          "inventory": {},
          "events": []
        }
    ]
}

```

If there are no error messages then this should now be working.  Within a minute or so you should be able to query these data in New Relic with a query like:

```sql
FROM AviatrixGatewayStatusSample SELECT status 
```
## Configuring New Relic Lookup Tables

In order to associate the data coming from the Aviatrix API with your account information you need to set up a lookup table with this information.  This is a manual step that currently needs to be updated when your gateways change.

In Aviatrix Copilot Navigate to `Cloud Fabric` -> `Gateways` -> `Gateway Management`. Download a csv file of this table using the download button next to `Actions`. 

In New Relic Navigate to `Logs` -> `Lookup Tables`.  If this is the first time you have done this click `Add Table`.  Name the table `Accounts` and select the csv file you just downloaded. When you want to update this table click `...` next to the table and select replace.

## Importing the example dashboard

The json file in [./NR-dashboard-code/dashboard.json](./NR-dashboard-code/dashboard.json) contains an example dashboard.  Copy the contents of this file to your clipboard and then, in New Relic, got to `Dashboards` and click `Import Dashboard`.  Paste the json and click `Import Dashboard` again.
You should now see the dashboard `Aviatrix Status Dashboard`.

## Integration Details

The integration will populate the following tables in New Relic:

- `AviatrixBgpStatusSample` Bgp routing status
- `AviatrixGatewayStatusSample` Aviatrix Gateway status
- `AviatrixTunnelStatusSample` Aviatrix Tunnel status
- `AviatrixGWMetricsUriSample` Aviatrix Gateway VM Metrics
- `AviatrixMetricsUriSample` Aviatrix Interface Metrics