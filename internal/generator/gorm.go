package generator

import (
	"context"
	"log/slog"

	"github.com/aburizalpurnama/gofer/internal/contract"
	"github.com/aburizalpurnama/gofer/internal/model"
)

var _ contract.BackLayerGenerator = new(gormGenerator)

type gormGenerator struct {
	logger *slog.Logger
	writer contract.Writer
}

func newGormGenerator(logger *slog.Logger, writer contract.Writer) *gormGenerator {
	return &gormGenerator{
		logger: logger,
		writer: writer,
	}
}

// func (b *generator) Generate(ctx context.Context, targetPath string, data model.ModelTemplateData) error {
// 	path := fmt.Sprintf("internal/app/model/.go", data.StructNam)

// 	return g.writer.WriteModel(ctx, targetPath + "")
// }

func (b *gormGenerator) GenerateModel(ctx context.Context, targetPath string, data model.ModelTemplateData) error {
	return b.writer.WriteModel(ctx, targetPath, "model_gorm.go.tpl", data)
}

func (b *gormGenerator) GenerateRepository(ctx context.Context, targetPath string, data model.RepositoryTemplateData) error {
	// return b.writer.WriteRepository(ctx, targetPath, "gorm_model.go.tpl", data)
	return nil
}
