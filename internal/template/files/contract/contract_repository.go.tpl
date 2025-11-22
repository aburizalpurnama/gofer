package contract

import (
	"context"

	{{ .ModuleName }}/internal/app/model"
)

type ProductRepository interface {
	FindAll(ctx context.Context, page *int, size *int) ([]model.Product, error)
	Count(ctx context.Context) (int64, error)
	FindByID(ctx context.Context, id uint) (*model.Product, error)
	Save(ctx context.Context, user *model.Product) (*model.Product, error)
	Update(ctx context.Context, user *model.Product) (*model.Product, error)
	Delete(ctx context.Context, id uint) error
}
