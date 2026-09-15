.SILENT:

CHART_DIRS := $(wildcard charts/*/)

.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -hE '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

generate: docs schemas

.PHONY: docs
docs: ## Generate Helm chart documentation
	for dir in $(CHART_DIRS); do \
		if [ -f "$$dir/values.yaml" ]; then \
			(cd "$$dir" && helm-docs); \
		fi \
	done

.PHONY: schemas
schemas:
	for dir in $(CHART_DIRS); do \
		if [ -f "$$dir/values.yaml" ]; then \
			(cd "$$dir" && helm schema --values values.yaml -o values.schema.json  --use-helm-docs); \
		fi \
	done

.PHONY: install-tools
install-tools: ## Install necessary tools for Helm chart development
	go install github.com/norwoodj/helm-docs/cmd/helm-docs@v1.14.2
	helm plugin install https://github.com/losisin/helm-values-schema-json.git --version v2.6.0 --verify=false 2>/dev/null || true
