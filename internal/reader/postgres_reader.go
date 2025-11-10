package reader

import (
	"context"

	"github.com/aburizalpurnama/gofer/internal/contract"
	"github.com/aburizalpurnama/gofer/internal/model"
	"github.com/jmoiron/sqlx"
)

// check if it satisfies the contract
var _ contract.Reader = new(postgresReader)

type postgresReader struct {
	db *sqlx.DB
}

func NewPostgres(db *sqlx.DB) *postgresReader {
	return &postgresReader{db}
}

func (r *postgresReader) ReadAllColumns(ctx context.Context) ([]model.ColumnSchema, error) {
	query := `
		SELECT
			c.column_name,
			c.data_type,
			c.is_nullable,
			c.character_maximum_length,
			c.column_default,
			c.ordinal_position
		FROM
			information_schema.columns c
		WHERE
			c.table_schema NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
		ORDER BY
			c.table_schema,
			c.table_name,
			c.ordinal_position;
	`

	var columns []model.ColumnSchema
	err := r.db.SelectContext(ctx, &columns, query)
	if err != nil {
		return nil, err
	}

	return columns, nil
}
