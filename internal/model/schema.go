package model

type ColumnSchema struct {
	ColumnName             string  `db:"column_name"`
	TableSchema            string  `db:"table_schema"`
	TableName              string  `db:"table_name"`
	DataType               string  `db:"data_type"`
	IsNullable             string  `db:"is_nullable"`
	CharacterMaximumLength *int    `db:"character_maximum_length"`
	ColumnDefault          *string `db:"column_default"`
	OrdinalPosition        int     `db:"ordinal_position"`
}
