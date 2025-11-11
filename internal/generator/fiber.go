package generator

import (
	"context"
	"log/slog"

	"github.com/aburizalpurnama/gofer/internal/contract"
	"github.com/aburizalpurnama/gofer/internal/model"
)

var _ contract.FrontLayerGenerator = new(fiberGenerator)

type fiberGenerator struct {
	logger *slog.Logger
	writer contract.Writer
}

func newFiberGenerator(logger *slog.Logger, writer contract.Writer) *fiberGenerator {
	return &fiberGenerator{
		logger: logger,
		writer: writer,
	}
}

func (b *fiberGenerator) GenerateHandler(ctx context.Context, targetPath string, data model.HandlerTemplateData) error {

	return nil
}

func (b *fiberGenerator) GenerateRoute(ctx context.Context, targetPath string, data model.RoutesTemplateData) error {

	return nil
}
