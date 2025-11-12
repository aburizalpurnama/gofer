module {{ .ModuleName }}

go {{ .GoVersion }}

require (
	github.com/caarlos0/env/v11 v11.3.1
	github.com/go-playground/validator/v10 v10.22.0
	github.com/go-sql-driver/mysql v1.9.3
	github.com/gofiber/fiber/v2 v2.52.5
	github.com/google/uuid v1.6.0
	github.com/jinzhu/copier v0.4.0
	github.com/joho/godotenv v1.5.1
	golang.org/x/crypto v0.43.0
	golang.org/x/sync v0.17.0
	gorm.io/datatypes v1.2.7
	gorm.io/driver/mysql v1.5.6
	gorm.io/driver/postgres v1.5.9
	gorm.io/gorm v1.30.0
)