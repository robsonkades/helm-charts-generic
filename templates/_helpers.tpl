{{/* Create a default fully qualified app name.
    We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
    If release name contains chart name it will be used as a full name. */}}
{{- define "abdocs.name" -}}
{{- if .Values.appConfig.name }}
{{- .Values.appConfig.name | trunc 63 | lower | replace " " "-" }}
{{- else }}
{{- $name := default .Chart.Name }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | lower | replace " " "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | lower | replace " " "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/* Common labels */}}
{{- define "abdocs.labels" -}}
helm.sh/chart: {{ include "abdocs.chart" . }}
{{ include "abdocs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels */}}
{{- define "abdocs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "abdocs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Create the name of the service account to use */}}
{{- define "abdocs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "abdocs.name" .) .Values.serviceAccount.name | trunc 63 | lower | replace " " "-" }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "abdocs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}