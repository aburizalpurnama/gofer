package contract

import (
	"context"

	"github.com/aburizalpurnama/gofer/internal/model"
)

type Reader interface {
	ReadAllColumns(ctx context.Context) ([]model.ColumnSchema, error)
}

type Builder interface {
	Build(ctx context.Context) error
}

type Writer interface {
	WriteModel(ctx context.Context, targetPath string, templateName string, data model.ModelTemplateData) error
}

type GeneratorFactory interface {
	CreateGenerator()
}

type FrontLayerGenerator interface {
	GenerateHandler(ctx context.Context, targetPath string, data model.HandlerTemplateData) error
	GenerateRoute(ctx context.Context, targetPath string, data model.RoutesTemplateData) error
}
type BackLayerGenerator interface {
	GenerateModel(ctx context.Context, targetPath string, data model.ModelTemplateData) error
	GenerateRepository(ctx context.Context, targetPath string, data model.RepositoryTemplateData) error
}

type ServiceLayerGenerator interface {
	GenerateService(ctx context.Context, targetPath string, data model.ServiceTemplateData) error
}

type Generator interface {
	FrontLayerGenerator
	ServiceLayerGenerator
	BackLayerGenerator
}
