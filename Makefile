.PHONY: fmt
fmt:
	scripts/fmt.sh

.PHONY: access
access:
	scripts/access.sh

.PHONY: pull-charts
pull-charts:
	scripts/pull-chart-elasticsearch.sh
	scripts/pull-chart-kibana.sh
	scripts/pull-chart-nifi.sh
