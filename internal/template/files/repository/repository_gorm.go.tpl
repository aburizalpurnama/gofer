package {{ .PackageName }}

import (
	"context"
	"time"

	"{{ .ModuleName }}/internal/app/contract"
	"{{ .ModuleName }}/internal/app/model"
	"{{ .ModuleName }}/internal/pkg/paginator"
	"gorm.io/gorm"
)

// check if the implementation satisfied its contract
var _ contract.{{ .ModelStructName }}Repository = new (productRepository)

type productRepository struct {
	db *gorm.DB
}

// New{{ .ModelStructName }}Repository membuat instance baru dari GORM repository
func New{{ .ModelStructName }}Repository(db *gorm.DB) *productRepository {
	return &productRepository{db: db}
}

func (r *productRepository) FindAll(ctx context.Context, page *int, size *int) (products []model.{{ .ModelStructName }}, err error) {
	// .Where("deleted_on IS NULL")
	query := r.db
	if page != nil && size != nil {
		offset := paginator.GetOffset(*page, *size)
		query.Offset(offset).Limit(*size)
	}

	err = query.Find(&products).Error
	return products, err
}

func (r *productRepository) Count(ctx context.Context) (count int64, err error) {
	// .Where("deleted_on IS NULL")
	query := r.db.Model(&model.{{ .ModelStructName }}{})
	err = query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return
}

func (r *productRepository) FindByID(ctx context.Context, id uint) (*model.{{ .ModelStructName }}, error) {
	var product model.{{ .ModelStructName }}
	err := r.db.Where("deleted_on IS NULL").First(&product, id).Error
	return &product, err
}

func (r *productRepository) Save(ctx context.Context, product *model.{{ .ModelStructName }}) (*model.{{ .ModelStructName }}, error) {
	err := r.db.Create(product).Error
	return product, err
}

func (r *productRepository) Update(ctx context.Context, product *model.{{ .ModelStructName }}) (*model.{{ .ModelStructName }}, error) {
	err := r.db.Save(product).Error
	return product, err
}

func (r *productRepository) Delete(ctx context.Context, id uint) error {
	return r.db.Model(&model.{{ .ModelStructName }}{}).Where("id = ?", id).Update("deleted_on", time.Now()).Error
}
