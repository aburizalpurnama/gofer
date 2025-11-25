package {{ .PackageName }}

import (
	{{- if .Imports }}
	{{- range .Imports }}
	"{{ . }}"
	{{- end }}
	{{- end }}
)

// {{ .EntityName }} represents the GORM model for the "{{ .TableName }}" table.
type {{ .EntityName }} struct {
{{- range .Fields }}
	{{ .Name }} {{ .Type }} `{{ .Tag }}`
{{- end }}
}

// TableName overrides the default table name to include the schema.
func ({{ .EntityName }}) TableName() string {
	return "{{ .TableName }}"
}

// {{ .EntityName }}Filter defines the available filter criteria for querying {{ .EntityVarName }}s.
type {{ .EntityName }}Filter struct {
	// You can customize filters here. This is just a placeholder based on the provided example.
	// Example: IsActive *bool `query:"is_active"`
	// Example: Search   *string `query:"search" search:"name,description"`
	{{- if .HasIsActive }}
	IsActive *bool   `query:"is_active"`
	{{- end }}
	Search   *string `query:"search" search:"{{ .SearchableFields }}"`
}