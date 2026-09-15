# homepage

A Helm chart for the Homepage application

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

Helm charts for the [Homepage](https://github.com/gethomepage/homepage) application dashboard.

## Usage

### Setup

Add the Helm repository and install the chart:

```sh
helm repo add aidan-wallace https://aidan-wallace.github.io/charts
helm upgrade -i homepage aidan-wallace/homepage
```

### Port Forwarding

Access the application locally by port-forwarding the service:

```sh
kubectl -n homepage port-forward svc/homepage 3000
```

### Example `values.yaml`

Below is an example configuration for deploying the chart:

```yaml
config:
  # Set this to the URL where the Homepage app is running.
  # localhost:3000 is added by default.
  allowedHosts: "homepage.local"

ingress:
  enabled: true
  hosts:
    - host: homepage.local
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: []
```

## Editing Configuration Files

Homepage configuration files are stored in the `config` directory inside the pod.

### Editing the `services.yaml` File

To edit the `services.yaml` file, use the following command:

```sh
kubectl -n homepage exec -it deployments/homepage -- vi config/services.yaml
```

## Config Provider

The config provider determines how the Homepage application retrieves its configuration files. The two available providers are:

- `configMap`: The default provider, which uses a Kubernetes ConfigMap to store configuration files.
- `s3Fetcher`: An alternative provider that fetches configuration files from an S3 bucket

### S3

### Configuration

Add the following configuration to your `values.yaml` file:

```yaml
config:
  provider: s3
  s3:
    accessKeyId: "aws access key id"
    secretAccessKey: "aws secret access key"
    region: "aws region"
    s3Path: "s3://path/to/config"
```

#### Example

To enable the S3 provider, deploy the chart with the above configuration.

### ConfigMap

### Configuration

Add the following configuration to your `values.yaml` file:

```yaml
config:
  provider: configMap
  configMap:
    services.yaml: |
      # This file will get added with the name 'services.yaml'
```

#### Example

To enable the ConfigMap provider, deploy the chart with the above configuration.

## homepage service file builder

The app entry builder is a sidecar container that scans for Kubernetes resource URLs and appends them to sections of the [`services.yaml`](https://gethomepage.dev/widgets/) file. This is useful for dynamically updating the application with deployed app information.

### Configuration

Add the following configuration to your `values.yaml` file:

```yaml
appEntryBuilder:
  enabled: true
  sleepIntervalSecs: 60
```

### Example

To enable the app entry builder, deploy the chart with the above configuration.

> **Note**: The app entry builder is currently a [private image and repo](https://github.com/aidan-Wallace/homepage-extensions/), but plans are in place to release it soon.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for the pods |
| appEntryBuilder | object | `{"enabled":false,"image":{"pullPolicy":"IfNotPresent","repository":"ghcr.io/aidan-wallace/homepage-extensions/homepage-annotations","tag":"latest"},"logLevel":"Information","resources":{},"sleepIterationSeconds":30}` | a sidecar container that will automatically build app entries for Homepage based off Kubernetes resources. url to the homepage app. |
| appEntryBuilder.enabled | bool | `false` | Enable the app entry builder sidecar. |
| appEntryBuilder.image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/aidan-wallace/homepage-extensions/homepage-annotations","tag":"latest"}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| appEntryBuilder.image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| appEntryBuilder.image.repository | string | `"ghcr.io/aidan-wallace/homepage-extensions/homepage-annotations"` | Container image repository. |
| appEntryBuilder.image.tag | string | `"latest"` | Overrides the image tag whose default is the chart appVersion. |
| appEntryBuilder.logLevel | string | `"Information"` | Log Level. [Trace, Debug, Information, Warning, Error, Critical] |
| appEntryBuilder.resources | object | `{}` | Resource requests and limits for the app entry builder sidecar. |
| appEntryBuilder.sleepIterationSeconds | int | `30` | Time to sleep between loop iterations |
| config | object | `{"allowedHosts":"example.local","configMap":{"bookmarks.yaml":"---\n# For configuration options and examples, please see:\n# https://gethomepage.dev/configs/bookmarks\n\n- Developer:\n    - Github:\n        - abbr: GH\n          href: https://github.com/\n\n- Social:\n    - Reddit:\n        - abbr: RE\n          href: https://reddit.com/\n\n- Entertainment:\n    - YouTube:\n        - abbr: YT\n          href: https://youtube.com/\n","custom.css":"/* Use this section to add custom CSS to your homepage */\n","custom.js":"// Use this section to add custom JS to your homepage\n","docker.yaml":"---\n# For configuration options and examples, please see:\n# https://gethomepage.dev/configs/docker/\n\n# my-docker:\n#   host: 127.0.0.1\n#   port: 2375\n\n# my-docker:\n#   socket: /var/run/docker.sock\n","kubernetes.yaml":"---\n# sample kubernetes config\n","proxmox.yaml":"---\n# pve:\n#   url: https://proxmox.host.or.ip:8006\n#   token: username@pam!Token ID\n#   secret: secret\n","services.yaml":"---\n# For configuration options and examples, please see:\n# https://gethomepage.dev/configs/services/\n\n- My First Group:\n    - My First Service:\n        href: http://localhost/\n        description: Homepage is awesome\n\n- My Second Group:\n    - My Second Service:\n        href: http://localhost/\n        description: Homepage is the best\n\n- My Third Group:\n    - My Third Service:\n        href: http://localhost/\n        description: Homepage is 😎\n","settings.yaml":"---\n# For configuration options and examples, please see:\n# https://gethomepage.dev/configs/settings/\n\nproviders:\n  openweathermap: openweathermapapikey\n  weatherapi: weatherapiapikey\n","widgets.yaml":"---\n# For configuration options and examples, please see:\n# https://gethomepage.dev/configs/info-widgets/\n\n- resources:\n    cpu: true\n    memory: true\n    disk: /\n\n- search:\n    provider: duckduckgo\n    target: _blank\n"},"extraFiles":[],"provider":"configMap","s3":{"accessKeyId":"","createSecret":true,"image":{"pullPolicy":"IfNotPresent","repository":"amazon/aws-cli","tag":"2.27.50"},"region":"","resources":{},"s3Path":"","secretAccessKey":"","secretName":"aws-secrets"}}` | Homepage application configuration. |
| config.allowedHosts | string | `"example.local"` | Specifies the allowed domains that can access the Homepage application. More information can be found here: https://github.com/gethomepage/homepage/blob/dev/docs/installation/index.md#homepage_allowed_hosts |
| config.configMap | object | `{"bookmarks.yaml":"---\n# For configuration options and examples, please see:\n# https://gethomepage.dev/configs/bookmarks\n\n- Developer:\n    - Github:\n        - abbr: GH\n          href: https://github.com/\n\n- Social:\n    - Reddit:\n        - abbr: RE\n          href: https://reddit.com/\n\n- Entertainment:\n    - YouTube:\n        - abbr: YT\n          href: https://youtube.com/\n","custom.css":"/* Use this section to add custom CSS to your homepage */\n","custom.js":"// Use this section to add custom JS to your homepage\n","docker.yaml":"---\n# For configuration options and examples, please see:\n# https://gethomepage.dev/configs/docker/\n\n# my-docker:\n#   host: 127.0.0.1\n#   port: 2375\n\n# my-docker:\n#   socket: /var/run/docker.sock\n","kubernetes.yaml":"---\n# sample kubernetes config\n","proxmox.yaml":"---\n# pve:\n#   url: https://proxmox.host.or.ip:8006\n#   token: username@pam!Token ID\n#   secret: secret\n","services.yaml":"---\n# For configuration options and examples, please see:\n# https://gethomepage.dev/configs/services/\n\n- My First Group:\n    - My First Service:\n        href: http://localhost/\n        description: Homepage is awesome\n\n- My Second Group:\n    - My Second Service:\n        href: http://localhost/\n        description: Homepage is the best\n\n- My Third Group:\n    - My Third Service:\n        href: http://localhost/\n        description: Homepage is 😎\n","settings.yaml":"---\n# For configuration options and examples, please see:\n# https://gethomepage.dev/configs/settings/\n\nproviders:\n  openweathermap: openweathermapapikey\n  weatherapi: weatherapiapikey\n","widgets.yaml":"---\n# For configuration options and examples, please see:\n# https://gethomepage.dev/configs/info-widgets/\n\n- resources:\n    cpu: true\n    memory: true\n    disk: /\n\n- search:\n    provider: duckduckgo\n    target: _blank\n"}` | Homepage configuration files stored in a ConfigMap. |
| config.configMap."bookmarks.yaml" | string | The example configuration provided below will be used. | Homepage bookmarks configuration |
| config.configMap."custom.css" | string | The example configuration provided below will be used. | Homepage custom CSS configuration |
| config.configMap."custom.js" | string | The example configuration provided below will be used. | Homepage custom JS configuration |
| config.configMap."docker.yaml" | string | The example configuration provided below will be used. | Homepage Docker configuration |
| config.configMap."kubernetes.yaml" | string | The example configuration provided below will be used. | Homepage Kubernetes configuration |
| config.configMap."proxmox.yaml" | string | The example configuration provided below will be used. | Homepage Proxmox configuration |
| config.configMap."services.yaml" | string | The example configuration provided below will be used. | Homepage Services configuration |
| config.configMap."settings.yaml" | string | The example configuration provided below will be used. | Homepage Settings configuration |
| config.configMap."widgets.yaml" | string | The example configuration provided below will be used. | Homepage Widgets configuration |
| config.extraFiles | list | `[]` | Add extra files to the homepage configuration folder. Note that these files will be merged with the default configuration files and will override any existing configuration. |
| config.provider | string | `"configMap"` | Configuration provider for the homepage application. Can be either configMap or s3. |
| config.s3 | object | `{"accessKeyId":"","createSecret":true,"image":{"pullPolicy":"IfNotPresent","repository":"amazon/aws-cli","tag":"2.27.50"},"region":"","resources":{},"s3Path":"","secretAccessKey":"","secretName":"aws-secrets"}` | Fetch data from an S3 bucket that the homepage will use. |
| config.s3.accessKeyId | string | `""` | AWS access key ID. |
| config.s3.createSecret | bool | `true` | Create a secret to store aws-secrets. This can be disabled to allow the user to create the secrets |
| config.s3.image | object | `{"pullPolicy":"IfNotPresent","repository":"amazon/aws-cli","tag":"2.27.50"}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| config.s3.image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| config.s3.image.repository | string | `"amazon/aws-cli"` | Container image repository. |
| config.s3.image.tag | string | `"2.27.50"` | Overrides the image tag whose default is the chart appVersion. |
| config.s3.region | string | `""` | AWS region containing the bucket. |
| config.s3.resources | object | `{}` | Resource requests and limits for the S3 container. |
| config.s3.s3Path | string | `""` | Path within the S3 bucket. |
| config.s3.secretAccessKey | string | `""` | AWS secret access key. |
| config.s3.secretName | string | `"aws-secrets"` | Name of the secret containing AWS credentials. |
| fullnameOverride | string | `""` | This is to override the full chart name. |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/gethomepage/homepage","tag":"v1.4.0"}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.repository | string | `"ghcr.io/gethomepage/homepage"` | Container image repository. |
| image.tag | string | `"v1.4.0"` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | This is for the secrets for pulling an image from a private repository more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| ingress | object | `{"annotations":{},"auth":{"basicAuth":{"secretName":"homepage-basic-auth"},"enabled":false,"type":"basicAuth"},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | This block is for setting up the ingress for more information can be found here: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| ingress.annotations | object | `{}` | Annotations to add to the ingress. |
| ingress.auth | object | `{"basicAuth":{"secretName":"homepage-basic-auth"},"enabled":false,"type":"basicAuth"}` | Optional ingress authentication configuration. |
| ingress.auth.basicAuth.secretName | string | `"homepage-basic-auth"` | Secret containing the basic authentication credentials. |
| ingress.auth.enabled | bool | `false` | Enables authentication for the ingress. Currently, only traefik is supported. To enable auth, ingress.className must be set to traefik. |
| ingress.auth.type | string | `"basicAuth"` | Authentication type. Currently, only basicAuth is supported. Traefik middleware for auth documentation: https://doc.traefik.io/traefik/reference/routing-configuration/http/middlewares/basicauth/ Generate a secret for basic auth using the following command: kubectl create secret generic homepage-basic-auth --from-literal=users="$(htpasswd -nbB <username> <password>)" |
| ingress.className | string | `""` | Ingress class name. |
| ingress.enabled | bool | `false` | Enable ingress for the chart. |
| ingress.hosts | list | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | Hosts and paths served by the ingress. |
| ingress.hosts[0].host | string | `"chart-example.local"` | Hostname served by the ingress. |
| ingress.hosts[0].paths | list | `[{"path":"/","pathType":"ImplementationSpecific"}]` | URL paths served for this host. |
| ingress.hosts[0].paths[0].path | string | `"/"` | URL path served by the ingress. |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` | Path matching behavior. |
| ingress.tls | list | `[]` | TLS configuration for the ingress. |
| livenessProbe | object | `{"httpGet":{"path":"/","port":"http"}}` | This is to setup the liveness and readiness probes more information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/ |
| livenessProbe.httpGet | object | `{"path":"/","port":"http"}` | HTTP probe configuration. |
| livenessProbe.httpGet.path | string | `"/"` | HTTP path used by the liveness probe. |
| livenessProbe.httpGet.port | string | `"http"` | Named port used by the liveness probe. |
| nameOverride | string | `""` | This is to override the chart name. |
| nodeSelector | object | `{}` | node selector for the pods |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/ |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. For more information checkout: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/ |
| podSecurityContext | object | `{}` | Security context for the pod. |
| readinessProbe | object | `{"httpGet":{"path":"/","port":"http"}}` | Readiness probe configuration. |
| readinessProbe.httpGet | object | `{"path":"/","port":"http"}` | HTTP probe configuration. |
| readinessProbe.httpGet.path | string | `"/"` | HTTP path used by the readiness probe. |
| readinessProbe.httpGet.port | string | `"http"` | Named port used by the readiness probe. |
| replicaCount | int | `1` | This will set the replicaset count more information can be found here: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/ |
| resources | object | `{}` | Resource requests and limits for the main container. |
| securityContext | object | `{}` | Security context for the pod. |
| service | object | `{"port":3000,"type":"ClusterIP"}` | This is for setting up a service more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/ |
| service.port | int | `3000` | This sets the ports more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#field-spec-ports |
| service.type | string | `"ClusterIP"` | This sets the service type more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| serviceAccount | object | `{"annotations":{},"automount":true,"clusterRoleBinding":{"create":true,"roleName":"cluster-admin"},"create":true,"name":""}` | This section builds out the service account more information can be found here: https://kubernetes.io/docs/concepts/security/service-accounts/ |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.clusterRoleBinding | object | `{"create":true,"roleName":"cluster-admin"}` | Configuration for creating a ClusterRoleBinding. This is required by the app builder container |
| serviceAccount.clusterRoleBinding.create | bool | `true` | Specifies whether a ClusterRoleBinding should be created. |
| serviceAccount.clusterRoleBinding.roleName | string | `"cluster-admin"` | ClusterRole to bind to the service account. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Tolerations for the pods |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
