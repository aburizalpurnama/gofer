package generator

import (
	"context"
	"log/slog"

	"github.com/aburizalpurnama/gofer/internal/contract"
	"github.com/aburizalpurnama/gofer/internal/model"
)

var _ contract.ServiceLayerGenerator = new(serviceGenerator)

type serviceGenerator struct {
	logger *slog.Logger
	writer contract.Writer
}

func newServiceGenerator(logger *slog.Logger, writer contract.Writer) *serviceGenerator {
	return &serviceGenerator{
		logger: logger,
		writer: writer,
	}
}

func (b *serviceGenerator) GenerateService(ctx context.Context, targetPath string, data model.ServiceTemplateData) error {

	return nil
}
