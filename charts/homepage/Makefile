.SILENT:

DEFAULT_SETS = \
	--set ingress.enabled=true \
	--set ingress.className="traefik" \
	--set ingress.auth.enabled=true \
	--set appEntryBuilder.enabled=true

template:
	rm -rf .cache/charts
	helm template homepage charts/homepage --output-dir .cache/charts/cm -n homepage $(DEFAULT_SETS) \
		--set config.provider="configMap"
	helm template homepage charts/homepage --output-dir .cache/charts/s3 -n homepage $(DEFAULT_SETS) \
		--set config.provider="s3"
