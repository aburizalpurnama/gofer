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

type ServiceContractTemplateData struct {
	PackageName string
	ModulePath  string

	InterfaceName    string
	EntityName       string
	EntityNamePlural string
	EntityVarName    string

	PrimaryKeyType string
}

// Data untuk satu method repository di dalam UoW
type UoWRepositoryData struct {
	MethodName    string
	InterfaceType string
}

// Data utama untuk template UoW
type UoWTemplateData struct {
	PackageName   string
	InterfaceName string
	Repositories  []UoWRepositoryData
}

type DatabaseTemplateData struct {
	PackageName string // e.g., "database"
	ModulePath  string // e.g., "github.com/aburizalpurnama/travel"
}
