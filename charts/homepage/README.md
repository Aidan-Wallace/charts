<!-- markdownlint-disable MD024 -->

# homepage-helm

Helm charts for the [Homepage](https://github.com/gethomepage/homepage) application dashboard.

## Usage

### Setup

Add the Helm repository and install the chart:

```sh
helm repo add homepage https://aidan-wallace.github.io/homepage-kubernetes/
helm upgrade -i homepage homepage/homepage
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
