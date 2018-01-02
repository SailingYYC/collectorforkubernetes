{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "collectorforkubernetes.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "collectorforkubernetes.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Convert the Chart configutation to the format used by Collector for Kubernetes config file.
*/}}
{{- define "collectorforkubernetes.config" -}}
{{- $config := dict }}
{{- range $cat1, $values := pick .Values "general" "input" "output" "pipe" }}
  {{- range $key1, $value1 := $values }}
    {{- if kindIs "map" $value1 }}
      {{- $cat2 := printf "%s.%s" $cat1 $key1 }}
      {{- range $key2, $value2 := $value1 }}
        {{- if kindIs "map" $value2 }}
          {{- $cat3 := printf "%s::%s" $cat2 $key2 }}
          {{- range $key3, $value3 := $value2 }}
          {{- $_ := set $config $cat3 (append (pluck $cat3 $config | first) (printf "%s = %v" $key3 $value3)) }}
          {{- end }}
        {{- else }}
          {{- $_ := set $config $cat2 (append (pluck $cat2 $config | first) (printf "%s = %v" $key2 $value2)) }}
        {{- end }}
      {{- end }}
    {{- else }}
      {{- $_ := set $config $cat1 (append (pluck $cat1 $config | first) (printf "%s = %v" $key1 $value1)) }}
    {{- end }}
  {{- end }}
{{- end -}}
{{- range $cat, $values := $config }}
[{{ $cat }}]
{{ $values | join "\n" }}
{{ end }}
{{- end -}}
