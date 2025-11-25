package {{ .PackageName }}

import "github.com/gofiber/fiber/v2"

// NewRoute registers {{ .EntityVarName }}-related routes to the provided router group.
func NewRoute(router fiber.Router, handler *Handler) {
	// Group routes under /{{ .EntityNamePluralKebab }}
	// e.g., /products, /users, /booking-transactions
	group := router.Group("/{{ .EntityNamePluralKebab }}")

	group.Post("/", handler.Create{{ .EntityName }})
	group.Get("/", handler.Get{{ .EntityNamePlural }})
	group.Get("/:id", handler.Get{{ .EntityName }})
	group.Patch("/:id", handler.Update{{ .EntityName }})
	group.Delete("/:id", handler.Delete{{ .EntityName }})

    // define another {{ .EntityVarName }}-related routes here
}