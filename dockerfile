FROM newrelic/infrastructure:1.52.0

# disable the newrelic infrastructure agent from performing any additional monitoring
# using forwarder mode will only make it responsible for executing integrations
ENV NRIA_IS_FORWARD_ONLY true

# install jq
RUN apk add jq

# add lcocal files
ADD ./config/newrelic-infra.yml /etc/newrelic-infra.yml
ADD ./scripts /etc/newrelic-infra/integrations.d/
