package {{ .PackageName }}
{{ if .Imports }}
import (
{{- range .Imports }}
	"{{ . }}"
{{- end }}
)
{{- end }}

// {{ .StructName }} is a GORM model for the "{{ .TableName }}" table
type {{ .StructName }} struct {
{{- range .Fields }}
	{{ .Name }} {{ .Type }} `{{ .Tag }}`
{{- end }}
}

// TableName defines the complete table name including the schema for GORM
func ({{ .StructName }}) TableName() string {
	return "{{ .TableName }}"
}