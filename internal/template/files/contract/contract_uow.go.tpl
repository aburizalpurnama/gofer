package {{ .PackageName }}

import (
	"context"
)

// {{ .InterfaceName }} defines the interface for managing atomic database operations (transactions) and provides access to repositories.
type {{ .InterfaceName }} interface {
{{- range .Repositories }}
	// {{ .MethodName }} returns a {{ .InterfaceType }} bound to this unit of work.
	{{ .MethodName }}() {{ .InterfaceType }}
{{- end }}

	// RunInTransaction runs the given function 'fn' within a single atomic transaction.
	// If 'fn' returns an error, the transaction is rolled back.
	// If 'fn' succeeds, the transaction is committed.
	RunInTransaction(ctx context.Context, fn func(context.Context, {{ .InterfaceName }}) error) error
}
