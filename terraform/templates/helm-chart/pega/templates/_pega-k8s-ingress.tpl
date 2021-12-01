{{- define "pega.k8s.ingress" -}}
# Ingress to be used for {{ .name }}
kind: Ingress
apiVersion: extensions/v1beta1
metadata:
  name: {{ .name }}
  namespace: {{ .root.Release.Namespace }}
  annotations:
{{- $ingress := .node.ingress }}
{{- if $ingress.annotations }}
    # Custom annotations
{{ toYaml $ingress.annotations | indent 4 }}
{{- else }}
    # Ingress class used is 'traefik'
    kubernetes.io/ingress.class: traefik
{{- end }}
spec:
{{ if ( include "ingressTlsEnabled" . ) }}
{{- if $ingress.tls.secretName }}
{{ include "tlssecretsnippet" . }}
{{ end }}
{{ end }}
  rules:
  # The calls will be redirected from {{ .node.domain }} to below mentioned backend serviceName and servicePort.
  # To access the below service, along with {{ .node.domain }}, traefik http port also has to be provided in the URL.
  - host: {{ template "domainName" dict "node" .node }}
    http:
      paths: 
      {{ if and .root.Values.constellation (eq .root.Values.constellation.enabled true) }}
      - path: /c11n     
        backend:
          serviceName: constellation
          servicePort: 3000
      {{ end }}
      - backend: 
          serviceName: {{ .name }} 
          servicePort: {{ .node.service.port }}
---     
{{- end }}
