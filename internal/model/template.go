package model

type DBLibrary string
type WebFramerowk string

const (
	SQLX DBLibrary = "sqlx"
	GORM DBLibrary = "gorm"
)

const (
	FIBER WebFramerowk = "fiber"
	GIN   WebFramerowk = "gin"
	CHI   WebFramerowk = "chi"
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
}

type RepositoryTemplateData struct {
	PackageName string
	Imports     []string // Daftar impor yang unik
	StructName  string
	TableName   string
	Fields      []TemplateField
}

type ServiceTemplateData struct {
	PackageName string
	Imports     []string // Daftar impor yang unik
	StructName  string
	TableName   string
	Fields      []TemplateField
}

type HandlerTemplateData struct {
	PackageName string
	Imports     []string // Daftar impor yang unik
	StructName  string
	TableName   string
	Fields      []TemplateField
}

type RoutesTemplateData struct {
	PackageName string
	Imports     []string // Daftar impor yang unik
	StructName  string
	TableName   string
	Fields      []TemplateField
}
