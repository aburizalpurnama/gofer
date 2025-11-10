package model

import (
{{- range .Imports }}
	"{{ . }}"
{{- end }}
)

// {{ .StructName }} is a GORM model for table "{{ .TableName }}"
type {{ .StructName }} struct {
{{- range .Fields }}
	{{ .Name }} {{ .Type }} `{{ .Tag }}`
{{- end }}
}

// TableName defines complete table name including the table skema for GORM
func ({{ .StructName }}) TableName() string {
	return "{{ .TableName }}"
}
