package {{ .PackageName }}

import "{{ .ModulePath }}/internal/pkg/apperror"

// ==========================================================
// {{ .EntityName }} Error Constructors
// ==========================================================

// Err{{ .EntityName }}NotFound creates a new error for missing {{ .EntityVarName }} records.
func Err{{ .EntityName }}NotFound(err error) *apperror.AppError {
	return apperror.New(
		apperror.{{ .EntityName }}NotFound,
		"{{ .EntityVarName }} not found",
		err,
		nil,
	)
}