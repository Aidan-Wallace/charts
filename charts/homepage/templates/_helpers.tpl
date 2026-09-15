{{/*
Expand the name of the chart.
*/}}
{{- define "homepage.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the Homepage app builder container.
*/}}
{{- define "homepage.appBuilder" -}}
{{ .Chart.Name }}-app-entry-builder
{{- end }}

{{/*
Create the name of the S3 data fetcher container.
*/}}
{{- define "homepage.s3Name" -}}
{{ .Chart.Name }}-s3-fetcher
{{- end }}

{{/*
Create the name of the files configmap.
*/}}
{{- define "homepage.filesConfigMapName" -}}
{{ .Chart.Name }}-files
{{- end }}

{{/*
Create the name of the auth ingress middleware.
*/}}
{{- define "homepage.ingressAuthMiddlewareName" -}}
{{ .Chart.Name }}-ingress-auth
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "homepage.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "homepage.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "homepage.labels" -}}
helm.sh/chart: {{ include "homepage.chart" . }}
{{ include "homepage.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "homepage.selectorLabels" -}}
app.kubernetes.io/name: {{ include "homepage.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "homepage.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "homepage.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
