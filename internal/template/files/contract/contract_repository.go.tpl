package {{ .PackageName }}

import (
	"context"

	"{{ .ModulePath }}/internal/app/model"
)

// {{ .InterfaceName }} defines the standard database operations for the {{ .EntityName }} entity.
type {{ .InterfaceName }} interface {
	// FindAll retrieves a list of {{ .EntityVarName }}s based on pagination parameters and filter criteria.
	FindAll(ctx context.Context, page *int, size *int, filter *model.{{ .FilterName }}) ([]model.{{ .EntityName }}, error)

	// Count returns the total number of {{ .EntityVarName }}s that match the given filter.
	Count(ctx context.Context, filter *model.{{ .FilterName }}) (int64, error)

	// FindByID retrieves a single {{ .EntityVarName }} by its unique identifier.
	FindByID(ctx context.Context, id {{ .PrimaryKeyType }}) (*model.{{ .EntityName }}, error)

	// Save persists a new {{ .EntityVarName }} record to the database.
	Save(ctx context.Context, {{ .EntityVarName }} *model.{{ .EntityName }}) (*model.{{ .EntityName }}, error)

	// Update modifies an existing {{ .EntityVarName }} record in the database.
	Update(ctx context.Context, {{ .EntityVarName }} *model.{{ .EntityName }}) (*model.{{ .EntityName }}, error)

	// Delete removes a {{ .EntityVarName }} record from the database by its identifier.
	Delete(ctx context.Context, id {{ .PrimaryKeyType }}) error
}
