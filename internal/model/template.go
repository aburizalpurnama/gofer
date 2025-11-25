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
	PackageName      string   // e.g., "model"
	Imports          []string // e.g., ["time", "github.com/shopspring/decimal", "gorm.io/gorm"]
	EntityName       string   // e.g., "Product"
	EntityVarName    string   // e.g., "product"
	TableName        string   // e.g., "core.products"
	Fields           []TemplateField
	HasIsActive      bool   // true if the model has an IsActive field
	SearchableFields string // e.g., "name,description"
}

type RepositoryTemplateData struct {
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

type ErrorTemplateData struct {
	PackageName   string // e.g., "product"
	ModulePath    string // e.g., "github.com/aburizalpurnama/travel"
	EntityName    string // e.g., "Product" (PascalCase)
	EntityVarName string // e.g., "product" (camelCase, untuk pesan error)
}

type RouteTemplateData struct {
	PackageName           string // e.g., "product"
	EntityName            string // e.g., "Product" (PascalCase)
	EntityNamePlural      string // e.g., "Products" (PascalCase, untuk method handler)
	EntityVarName         string // e.g., "product" (camelCase, untuk komentar)
	EntityNamePluralKebab string // e.g., "products" atau "booking-transactions" (kebab-case, untuk URL)
}

type ServiceTemplateData struct {
	PackageName   string // "product"
	ModulePath    string // "github.com/aburizalpurnama/travel"
	InterfaceName string // "ProductService"

	EntityName       string // "Product"
	EntityNamePlural string // "Products"
	EntityVarName    string // "product"

	FilterName     string // "ProductFilter"
	PrimaryKeyType string // "uint" (atau "string" jika UUID)
}

type MiddlewareTemplateData struct {
	PackageName string // e.g., "middleware"
	ModulePath  string // e.g., "github.com/aburizalpurnama/travel"
}
