{{- define "docspring-enterprise.name" -}}
{{ .Chart.Name }}
{{- end -}}

{{- define "docspring-enterprise.sharedEnvVars" -}}
{{- if .Values.resources.postgres.enabled }}
- name: DATABASE_URL
  value: "postgres://{{ .Values.resources.postgres.auth.username }}:{{ .Values.resources.postgres.auth.password }}@{{ include "docspring-enterprise.name" . }}-postgres:5432/{{ .Values.resources.postgres.auth.database }}"
{{- end }}
{{- if .Values.resources.redis.enabled }}
- name: REDIS_URL
  value: "redis://{{ include "docspring-enterprise.name" . }}-redis:6379"
{{- end }}
{{- range $key, $value := .Values.sharedEnv }}
- name: {{ $key | quote }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}
