package model

type DBLibrary string

const (
	SQLX DBLibrary = "sqlx"
	GORM DBLibrary = "gorm"
)

type TemplateField struct {
	Name string // Nama field (e.g., "FullName")
	Type string // Tipe data Go (e.g., "string", "*time.Time", "decimal.Decimal")
	Tag  string // Struct tag (e.g., `gorm:"..."`)
}

type ModelTemplateData struct {
	PackageName string
	Imports     []string // Daftar impor yang unik
	StructName  string
	TableName   string
	Fields      []TemplateField
	DBLibrary   DBLibrary
}

type RepositoryTemplateData struct {
	PackageName string
	Imports     []string // Daftar impor yang unik
	StructName  string
	TableName   string
	Fields      []TemplateField
	DBLibrary   DBLibrary
}
