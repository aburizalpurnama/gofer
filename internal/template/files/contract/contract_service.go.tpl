package {{ .PackageName }}

import (
	"context"

	"{{ .ModulePath }}/internal/app/payload"
	"{{ .ModulePath }}/internal/pkg/response"
)

// {{ .InterfaceName }} defines the business logic operations available for the {{ .EntityName }} model.
type {{ .InterfaceName }} interface {
	// Create{{ .EntityName }} handles the creation of a new {{ .EntityVarName }} based on the provided request.
	Create{{ .EntityName }}(ctx context.Context, req payload.{{ .EntityName }}CreateRequest) (*payload.{{ .EntityName }}BaseResponse, error)

	// GetAll{{ .EntityNamePlural }} retrieves a list of {{ .EntityVarName }}s matching the criteria in the request, including pagination.
	GetAll{{ .EntityNamePlural }}(ctx context.Context, req payload.{{ .EntityName }}GetAllRequest) ([]payload.{{ .EntityName }}BaseResponse, *response.Pagination, error)

	// Get{{ .EntityName }}ByID retrieves the details of a specific {{ .EntityVarName }} identified by its ID.
	Get{{ .EntityName }}ByID(ctx context.Context, id {{ .PrimaryKeyType }}) (*payload.{{ .EntityName }}BaseResponse, error)

	// Update{{ .EntityName }} modifies an existing {{ .EntityVarName }} identified by its ID with the provided update data.
	Update{{ .EntityName }}(ctx context.Context, id {{ .PrimaryKeyType }}, req payload.{{ .EntityName }}UpdateRequest) (*payload.{{ .EntityName }}BaseResponse, error)

	// Delete{{ .EntityName }} removes a {{ .EntityVarName }} identified by its ID from the system.
	Delete{{ .EntityName }}(ctx context.Context, id {{ .PrimaryKeyType }}) error
}
