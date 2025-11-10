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
