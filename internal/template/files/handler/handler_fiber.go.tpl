package {{ .PackageName }}

import (
	"net/http"
	"strconv"

	"{{ .ModulePath }}/internal/app/contract"
	"{{ .ModulePath }}/internal/app/payload"
	"{{ .ModulePath }}/internal/pkg/apperror"
	"{{ .ModulePath }}/internal/pkg/httphelper"
	"{{ .ModulePath }}/internal/pkg/response"
	"{{ .ModulePath }}/internal/pkg/validator"
	"github.com/gofiber/fiber/v2"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/trace"
)

var handlerTracer trace.Tracer = otel.Tracer("{{ .EntityVarName }}.handler")

type Handler struct {
	service contract.{{ .EntityName }}Service
}

// NewHandler initializes a new instance of {{ .EntityName }}Handler.
func NewHandler(service contract.{{ .EntityName }}Service) *Handler {
	return &Handler{service: service}
}

// Create{{ .EntityName }} handles the creation of a new {{ .EntityVarName }}.
func (h *Handler) Create{{ .EntityName }}(c *fiber.Ctx) error {
	ctx, span := handlerTracer.Start(c.Context(), "Create{{ .EntityName }}")
	defer span.End()

	var req payload.{{ .EntityName }}CreateRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(http.StatusBadRequest).JSON(response.Error(apperror.BadRequest, "Request body is malformed.", nil))
	}

	if errPayload := validator.ValidateStruct(req); errPayload != nil {
		return c.Status(http.StatusBadRequest).JSON(
			response.APIResponse{Status: "error", Error: errPayload},
		)
	}

	{{ .EntityVarName }}, err := h.service.Create{{ .EntityName }}(ctx, req)
	if err != nil {
		c.Locals("error", err)

		var appErr *apperror.AppError
		if errors.As(err, &appErr) {
			return c.Status(httphelper.MapErrorToHTTPStatus(appErr.Code)).JSON(
				response.Error(appErr.Code, appErr.Message, appErr.Details),
			)
		}

		return c.Status(http.StatusInternalServerError).JSON(
			response.Error(apperror.Internal, "An unknown error occurred", nil),
		)
	}

	return c.Status(http.StatusCreated).JSON(response.Success({{ .EntityVarName }}, nil))
}

// Get{{ .EntityNamePlural }} retrieves a list of {{ .EntityVarName }}s with pagination and filtering.
func (h *Handler) Get{{ .EntityNamePlural }}(c *fiber.Ctx) error {
	ctx, span := handlerTracer.Start(c.Context(), "Get{{ .EntityNamePlural }}")
	defer span.End()

	req := payload.{{ .EntityName }}GetAllRequest{}
	if err := c.QueryParser(&req); err != nil {
		return c.Status(http.StatusBadRequest).JSON(response.Error(apperror.BadRequest, "Invalid query parameters", nil))
	}

	// Set default pagination values if not provided
	// req.SetDefault() // Ensure SetDefault is implemented in CommonGetAllRequest or similar

	{{ .EntityVarName }}s, pagination, err := h.service.GetAll{{ .EntityNamePlural }}(ctx, req)
	if err != nil {
		c.Locals("error", err)

		var appErr *apperror.AppError
		if errors.As(err, &appErr) {
			return c.Status(httphelper.MapErrorToHTTPStatus(appErr.Code)).JSON(
				response.Error(appErr.Code, appErr.Message, appErr.Details),
			)
		}

		return c.Status(http.StatusInternalServerError).JSON(
			response.Error(apperror.Internal, "An unknown error occurred", nil),
		)
	}

	return c.JSON(response.Success({{ .EntityVarName }}s, pagination))
}

// Get{{ .EntityName }} retrieves a single {{ .EntityVarName }} by its ID.
func (h *Handler) Get{{ .EntityName }}(c *fiber.Ctx) error {
	ctx, span := handlerTracer.Start(c.Context(), "Get{{ .EntityName }}")
	defer span.End()

	idStr := c.Params("id")
	// Assumes ID is uint based on your previous examples. 
	// If ID type varies (uuid, etc), generator logic needs to handle conversion dynamically.
	id, err := strconv.Atoi(idStr)
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(
			response.Error(apperror.Validation, "Invalid ID format", nil),
		)
	}

	{{ .EntityVarName }}, err := h.service.Get{{ .EntityName }}ByID(ctx, {{ .PrimaryKeyType }}(id))
	if err != nil {
		c.Locals("error", err)

		var appErr *apperror.AppError
		if errors.As(err, &appErr) {
			return c.Status(httphelper.MapErrorToHTTPStatus(appErr.Code)).JSON(
				response.Error(appErr.Code, appErr.Message, appErr.Details),
			)
		}

		return c.Status(http.StatusInternalServerError).JSON(
			response.Error(apperror.Internal, "An unknown error occurred", nil),
		)
	}

	return c.JSON(response.Success({{ .EntityVarName }}, nil))
}

// Update{{ .EntityName }} modifies an existing {{ .EntityVarName }} based on ID and payload.
func (h *Handler) Update{{ .EntityName }}(c *fiber.Ctx) error {
	ctx, span := handlerTracer.Start(c.Context(), "Update{{ .EntityName }}")
	defer span.End()

	idStr := c.Params("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(
			response.Error(apperror.Validation, "Invalid ID format", nil),
		)
	}

	var req payload.{{ .EntityName }}UpdateRequest
	if err := c.BodyParser(&req); err != nil {
		return c.Status(http.StatusBadRequest).JSON(response.Error(apperror.BadRequest, "Request body is malformed.", nil))
	}

	if errPayload := validator.ValidateStruct(req); errPayload != nil {
		return c.Status(http.StatusBadRequest).JSON(
			response.APIResponse{Status: "error", Error: errPayload},
		)
	}

	{{ .EntityVarName }}, err := h.service.Update{{ .EntityName }}(ctx, {{ .PrimaryKeyType }}(id), req)
	if err != nil {
		c.Locals("error", err)

		var appErr *apperror.AppError
		if errors.As(err, &appErr) {
			return c.Status(httphelper.MapErrorToHTTPStatus(appErr.Code)).JSON(
				response.Error(appErr.Code, appErr.Message, appErr.Details),
			)
		}

		return c.Status(http.StatusInternalServerError).JSON(
			response.Error(apperror.Internal, "An unknown error occurred", nil),
		)
	}

	return c.JSON(response.Success({{ .EntityVarName }}, nil))
}

// Delete{{ .EntityName }} removes a {{ .EntityVarName }} by its ID.
func (h *Handler) Delete{{ .EntityName }}(c *fiber.Ctx) error {
	ctx, span := handlerTracer.Start(c.Context(), "Delete{{ .EntityName }}")
	defer span.End()

	idStr := c.Params("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		return c.Status(http.StatusBadRequest).JSON(
			response.Error(apperror.Validation, "Invalid ID format", nil),
		)
	}

	if err := h.service.Delete{{ .EntityName }}(ctx, {{ .PrimaryKeyType }}(id)); err != nil {
		c.Locals("error", err)

		var appErr *apperror.AppError
		if errors.As(err, &appErr) {
			return c.Status(httphelper.MapErrorToHTTPStatus(appErr.Code)).JSON(
				response.Error(appErr.Code, appErr.Message, appErr.Details),
			)
		}

		return c.Status(http.StatusInternalServerError).JSON(
			response.Error(apperror.Internal, "An unknown error occurred", nil),
		)
	}

	return c.JSON(response.Success(nil, nil))
}