package {{ .PackageName }}

import (
	"{{ .ModuleName }}/internal/app/contract"
	"{{ .ModuleName }}/internal/app/model"
	"{{ .ModuleName }}/internal/pkg/repository"
	"gorm.io/gorm"
)

// Repository implements the contract.{{.ContractName}} interface.
// It embeds a generic GORM repository to handle basic CRUD operations.
type Repository struct {
	*repository.GORM[model.{{.ModelName}}, model.{{.FilterName}}]
}

// NewRepository creates a new {{ .PackageName }} repository instance.
func NewRepository(db *gorm.DB) *Repository {
	// Initialize the embedded generic GORM repository
	gormRepo := repository.NewGORM[model.{{.ModelName}}, model.{{.FilterName}}](db)
	
	return &Repository{
		GORM: gormRepo,
	}
}

// Ensures Repository satisfies the contract at compile-time.
var _ contract.{{.ContractName}} = (*Repository)(nil)

// Add your custom, {{ .PackageName }}-specific repository methods below