package {{ .PackageName }}
{{ if .Imports }}
import (
{{- range .Imports }}
	"{{ . }}"
{{- end }}
)
{{- end }}

// {{ .StructName }} is a struct model for the "{{ .TableName }}" table
type {{ .StructName }} struct {
{{- range .Fields }}
	{{ .Name }} {{ .Type }} `{{ .Tag }}`
{{- end }}
}